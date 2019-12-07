import 'package:mutex/mutex.dart';
import 'package:redux/redux.dart';
import 'package:requests/requests.dart';

import '../actions.dart';
import '../app_state.dart';
import '../wrapper.dart';

List<Middleware<AppState>> gradesMiddlewares(Wrapper wrapper) {
  _gradesLock = SemesterLock((s) async {
    await Requests.get("${wrapper.baseAddress}/?semesterWechsel=${s.n}");
  });
  return [
    TypedMiddleware<AppState, LoadSubjectsAction>(
      (store, action, next) => _load(next, action, wrapper, store),
    ),
    TypedMiddleware<AppState, LoadSubjectDetailsAction>(
      (store, action, next) => _loadDetail(store, next, action, wrapper),
    ),
    TypedMiddleware(_setSemester),
  ];
}

const String _subjects = "/api/student/all_subjects";
const String _subjectsDetail = "/api/student/subject_detail";

SemesterLock _gradesLock;

void _setSemester(Store<AppState> store, SetGradesSemesterAction action,
    NextDispatcher next) {
  store.dispatch(LoadSubjectsAction(action.newSemester));
  next(action);
}

void _load(NextDispatcher next, LoadSubjectsAction action, Wrapper wrapper,
    Store<AppState> store) async {
  next(action);

  if (await wrapper.noInternet) {
    store.dispatch(NoInternetAction(true));
    return;
  }

  _doForSemester(
    action.semester == Semester.all
        ? [Semester.first, Semester.second]
        : [action.semester],
    (s) async {
      var data = await wrapper.post(
        _subjects,
        {"studentId": store.state.config.userId},
      );
      store.dispatch(SubjectsLoadedAction(data, s));
      store.dispatch(UpdateGradesGraphConfigsAction(
          store.state.gradesState.subjects.toList()));
    },
  );
}

void _loadDetail(Store<AppState> store, NextDispatcher next,
    LoadSubjectDetailsAction action, Wrapper wrapper) async {
  next(action);

  if (await wrapper.noInternet) {
    store.dispatch(NoInternetAction(true));
    return;
  }

  _doForSemester(
    action.semester == Semester.all
        ? [Semester.first, Semester.second]
        : [action.semester],
    (s) async {
      var data = await wrapper.post(_subjectsDetail, {
        "studentId": store.state.config.userId,
        "subjectId": action.subject.id
      });
      store.dispatch(SubjectLoadedAction(data, s, action.subject));
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
