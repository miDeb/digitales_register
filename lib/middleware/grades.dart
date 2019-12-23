part of 'middleware.dart';

final _gradesMiddleware =
    MiddlewareBuilder<AppState, AppStateBuilder, AppActions>()
      ..add(GradesActionsNames.setSemester, _setSemester)
      ..add(GradesActionsNames.load, _loadGrades)
      ..add(GradesActionsNames.loadDetails, _loadGradesDetails);

final _gradesLock = SemesterLock((s) async {
  await Requests.get("${_wrapper.baseAddress}/?semesterWechsel=${s.n}");
});

const String _subjects = "/api/student/all_subjects";
const String _subjectsDetail = "/api/student/subject_detail";

void _setSemester(MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next, Action<Semester> action) {
  next(action);
  api.actions.gradesActions.load(action.payload);
}

void _loadGrades(MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next, Action<Semester> action) async {
  if (await _wrapper.noInternet) {
    api.actions.noInternet(true);
    return;
  }
  next(action);
  _doForSemester(
    action.payload == Semester.all
        ? [Semester.first, Semester.second]
        : [action.payload],
    (s) async {
      var data = await _wrapper.post(
        _subjects,
        {"studentId": api.state.config.userId},
      );
      api.actions.gradesActions.loaded(
        SubjectsLoadedPayload(
          (b) => b
            ..data = data
            ..semester = s.toBuilder(),
        ),
      );
      api.actions.settingsActions
          .updateGraphConfig(api.state.gradesState.subjects);
    },
  );
}

void _loadGradesDetails(
    MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next,
    Action<LoadSubjectDetailsPayload> action) async {
  next(action);

  if (await _wrapper.noInternet) {
    api.actions.noInternet(true);
    return;
  }

  _doForSemester(
    action.payload.semester == Semester.all
        ? [Semester.first, Semester.second]
        : [action.payload.semester],
    (s) async {
      var data = await _wrapper.post(_subjectsDetail, {
        "studentId": api.state.config.userId,
        "subjectId": action.payload.subject.id
      });
      api.actions.gradesActions.detailsLoaded(
        SubjectDetailLoadedPayload(
          (b) => b
            ..data = data
            ..semester = s.toBuilder()
            ..subject = action.payload.subject.toBuilder(),
        ),
      );
    },
  );
}

void _doForSemester(
  List<Semester> semester,
  Future<void> f(Semester s),
) {
  final currentSemester = _gradesLock.current;
  if (semester.contains(currentSemester)) {
    semester.remove(currentSemester);
    _gradesLock.synchronized(currentSemester, () => f(currentSemester));
  }
  for (final s in semester) {
    _gradesLock.synchronized(s, () => f(s));
  }
}

typedef Future<void> SemesterChangeCallback(Semester semester);
typedef Future<void> AsyncVoidCallback();

class SemesterLock {
  Semester current;
  int usersOfCurrent = 0;
  final SemesterChangeCallback semesterChangeCallback;
  SemesterLock(this.semesterChangeCallback);
  final _mutex = Mutex();
  Map<Semester, List<AsyncVoidCallback>> waitlist = {};
  void synchronized(Semester semester, Future<void> f()) async {
    await _mutex.acquire();
    bool mutexAquired = true;
    if (usersOfCurrent == 0 || semester == current) {
      usersOfCurrent++;
      if (semester != current) {
        await semesterChangeCallback(semester);
        current = semester;
      }
      _mutex.release();
      mutexAquired = false;
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
        waitlist[semester].add(f);
      } else {
        waitlist[semester] = [f];
      }
    }
    if (mutexAquired) {
      _mutex.release();
    }
  }
}
