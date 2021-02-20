part of 'middleware.dart';

final _gradesMiddleware = MiddlewareBuilder<AppState, AppStateBuilder,
    AppActions>()
  ..add(GradesActionsNames.setSemester, _setSemester)
  ..add(GradesActionsNames.load, _loadGrades)
  ..add(GradesActionsNames.loadDetails, _loadGradesDetails)
  ..add(GradesActionsNames.loadCancelledDescription, _loadCancelledDescription);

final _gradesLock = SemesterLock((s) async {
  await _wrapper.send("?semesterWechsel=${s.n}");
});

const String _subjects = "api/student/all_subjects";
const String _subjectsDetail = "api/student/subject_detail";
const String _grade = "api/student/entry/getGrade";

Future<void> _setSemester(
    MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next,
    Action<Semester> action) async {
  await next(action);
  api.actions.gradesActions.load(action.payload);
}

Future<void> _loadGrades(
    MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next,
    Action<Semester> action) async {
  if (api.state.noInternet) return;

  await next(action);
  _doForSemester(
    action.payload == Semester.all
        ? [Semester.first, Semester.second]
        : [action.payload],
    (s) async {
      final dynamic data = await _wrapper.send(
        _subjects,
        args: {"studentId": api.state.config!.userId},
      );
      if (data == null) {
        api.actions.refreshNoInternet();
        return;
      }
      api.actions.gradesActions.loaded(
        SubjectsLoadedPayload(
          (b) => b
            ..data = data
            ..semester = s.toBuilder(),
        ),
      );
    },
  );
}

Future<void> _loadGradesDetails(
    MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next,
    Action<LoadSubjectDetailsPayload> action) async {
  if (api.state.noInternet) return;

  await next(action);

  _doForSemester(
    action.payload.semester == Semester.all
        ? [Semester.first, Semester.second]
        : [action.payload.semester],
    (s) async {
      dynamic data = await _wrapper.send(
        _subjectsDetail,
        args: {
          "studentId": api.state.config!.userId,
          "subjectId": action.payload.subject.id
        },
      );
      if (data == null) {
        api.actions.refreshNoInternet();
        return;
      }
      if (data is String) {
        data = json.decode(data);
      }
      api.actions.gradesActions.detailsLoaded(
        SubjectDetailLoadedPayload(
          (b) => b
            ..data = data
            ..semester = s.toBuilder()
            ..subject = action.payload.subject.toBuilder(),
        ),
      );
      for (final grade in api.state.gradesState.subjects
          .firstWhere((s) => s.id == action.payload.subject.id)
          .grades[s]!
          .where((g) => g.cancelled)) {
        api.actions.gradesActions.loadCancelledDescription(
          LoadGradeCancelledDescriptionPayload(
            (b) => b
              ..semester = s.toBuilder()
              ..grade = grade.toBuilder(),
          ),
        );
      }
    },
  );
}

Future<void> _loadCancelledDescription(
    MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next,
    Action<LoadGradeCancelledDescriptionPayload> action) async {
  if (api.state.noInternet) return;

  await next(action);
  _doForSemester(
    [action.payload.semester],
    (s) async {
      final dynamic data = await _wrapper.send(
        _grade,
        args: {
          "gradeId": action.payload.grade.id,
        },
      );
      if (data == null) {
        api.actions.refreshNoInternet();
        return;
      }
      api.actions.gradesActions.cancelledDescriptionLoaded(
        GradeCancelledDescriptionLoadedPayload(
          (b) => b
            ..grade = action.payload.grade.toBuilder()
            ..semester = action.payload.semester.toBuilder()
            ..data = data,
        ),
      );
    },
  );
}

void _doForSemester(
  List<Semester> semester,
  Future<void> Function(Semester s) f,
) {
  final currentSemester = _gradesLock.current;
  if (semester.contains(currentSemester)) {
    semester.remove(currentSemester);
    _gradesLock.synchronized(currentSemester!, () => f(currentSemester));
  }
  for (final s in semester) {
    _gradesLock.synchronized(s, () => f(s));
  }
}

typedef SemesterChangeCallback = Future<void> Function(Semester semester);
typedef AsyncVoidCallback = Future<void> Function();

class SemesterLock {
  Semester? current;
  int usersOfCurrent = 0;
  final SemesterChangeCallback semesterChangeCallback;
  SemesterLock(this.semesterChangeCallback);
  final _mutex = Mutex();
  Map<Semester, List<AsyncVoidCallback>> waitlist = {};

  Future<void> synchronized(
      Semester semester, Future<void> Function() f) async {
    await _mutex.acquire();
    bool mutexAcquired = true;
    if (usersOfCurrent == 0 || semester == current) {
      usersOfCurrent++;
      if (semester != current) {
        await semesterChangeCallback(semester);
        current = semester;
      }
      _mutex.release();
      mutexAcquired = false;
      await f();
      if (usersOfCurrent == 1 && waitlist.isNotEmpty) {
        final last = waitlist.entries.first;
        waitlist.remove(last.key);
        for (final f in last.value) {
          synchronized(last.key, f);
        }
      }
      usersOfCurrent--;
    } else {
      if (waitlist.containsKey(semester)) {
        waitlist[semester]!.add(f);
      } else {
        waitlist[semester] = [f];
      }
    }
    if (mutexAcquired) {
      _mutex.release();
    }
  }
}
