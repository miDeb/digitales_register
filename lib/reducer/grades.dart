import 'package:redux/redux.dart';

import '../actions.dart';
import '../app_state.dart';

final gradesReducer = combineReducers<GradesStateBuilder>([
  _loadSubjectsReducer,
  TypedReducer<GradesStateBuilder, SetGraphConfigsAction>(
      _setGradesGraphConfigRecuder),
  TypedReducer<GradesStateBuilder, SubjectsLoadedAction>(
      _subjectsLoadedReducer),
  TypedReducer<GradesStateBuilder, SetGradesSemesterAction>(
      _setGradesSemesterReducer),
  TypedReducer<GradesStateBuilder, LoggedInAgainAutomatically>(
    _afterAutoRelogin,
  ),
]);
GradesStateBuilder _loadSubjectsReducer(GradesStateBuilder state, action) {
  if (action is LoadSubjectsAction) {
    return state..loading = true;
  } else if (action is NoInternetAction) {
    return state..loading = false;
  } else
    return state;
}

GradesStateBuilder _subjectsLoadedReducer(
    GradesStateBuilder state, SubjectsLoadedAction action) {
  return state
    ..subjects = action.subjects
    ..serverSemester = action.lastRequestedSemester
    ..loading = false;
}

GradesStateBuilder _setGradesGraphConfigRecuder(
    GradesStateBuilder state, SetGraphConfigsAction action) {
  return state..graphConfigs.replace(action.configs);
}

GradesStateBuilder _setGradesSemesterReducer(
    GradesStateBuilder state, SetGradesSemesterAction action) {
  return state..semester.replace(action.newSemester);
}

GradesStateBuilder _afterAutoRelogin(
    GradesStateBuilder state, LoggedInAgainAutomatically action) {
  return state..serverSemester = null;
}
