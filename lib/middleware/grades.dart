import 'package:redux/redux.dart';
import 'package:requests/requests.dart';
import 'package:synchronized/synchronized.dart';

import '../actions.dart';
import '../app_state.dart';
import '../wrapper.dart';

List<Middleware<AppState>> gradesMiddlewares(Wrapper wrapper) => [
      TypedMiddleware<AppState, LoadSubjectsAction>(
        (store, action, next) => _load(next, action, wrapper, store),
      ),
      TypedMiddleware<AppState, LoadSubjectDetailsAction>(
        (store, action, next) => _loadDetail(store, next, action, wrapper),
      ),
      TypedMiddleware(_setSemester),
    ];

const String _subjects = "/api/student/all_subjects";
const String _subjectsDetail = "/api/student/subject_detail";

final _gradesLock = new Lock();

void _setSemester(Store<AppState> store, SetGradesSemesterAction action,
    NextDispatcher next) {
  store.dispatch(LoadSubjectsAction(action.newSemester));
  next(action);
}

void _load(NextDispatcher next, LoadSubjectsAction action, Wrapper wrapper,
    Store<AppState> store) {
  next(action);

  _gradesLock.synchronized(() async {
    if (await wrapper.noInternet) {
      store.dispatch(NoInternetAction(true));
      return;
    }
    if (action.semester == Semester.all) {
      store.dispatch(LoadSubjectsAction(Semester.first));
      store.dispatch(LoadSubjectsAction(Semester.second));
      return;
    }
    if (action.semester != store.state.gradesState.serverSemester) {
      await Requests.get(
          "${wrapper.baseAddress}/?semesterWechsel=${action.semester.n}");
    }
    var data = await wrapper.post(_subjects, {
      "studentId": store.state.config.userId,
    });
    store.dispatch(SubjectsLoadedAction(data, action.semester));
    store.dispatch(UpdateGradesGraphConfigsAction(
        store.state.gradesState.subjects.toList()));
  });
}

void _loadDetail(Store<AppState> store, NextDispatcher next,
    LoadSubjectDetailsAction action, Wrapper wrapper) {
  next(action);

  _gradesLock.synchronized(() async {
    if (await wrapper.noInternet) {
      store.dispatch(NoInternetAction(true));
      return;
    }
    if (action.semester == Semester.all) {
      store.dispatch(
        LoadSubjectDetailsAction(
          action.subject,
          Semester.first,
        ),
      );
      store.dispatch(
        LoadSubjectDetailsAction(
          action.subject,
          Semester.second,
        ),
      );
      return;
    }
    if (action.semester != store.state.gradesState.serverSemester) {
      await Requests.get(
          "${wrapper.baseAddress}/?semesterWechsel=${action.semester.n}");
    }
    var data = await wrapper.post(_subjectsDetail, {
      "studentId": store.state.config.userId,
      "subjectId": action.subject.id
    });
    store.dispatch(SubjectLoadedAction(data, action.semester, action.subject));
  });
}
