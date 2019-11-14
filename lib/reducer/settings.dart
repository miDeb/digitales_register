import 'package:redux/redux.dart';
import 'package:built_collection/built_collection.dart';

import '../actions.dart';
import '../app_state.dart';

SettingsStateBuilder settingsStateReducer(SettingsStateBuilder state, action) {
  return (state
    ..offlineEnabled = _offlineEnabledReducer(state.offlineEnabled, action)
    ..noDataSaving = _saveDataReducer(state.noDataSaving, action)
    ..noPasswordSaving = _savePassReducer(state.noPasswordSaving, action)
    ..askWhenDelete = _askWhenDeleteReducer(state.askWhenDelete, action)
    ..showCancelled = _showCancelledReducer(state.showCancelled, action)
    ..typeSorted = _sortByTypeReducer(state.typeSorted, action)
    ..deleteDataOnLogout = _deleteOnLogout(state.deleteDataOnLogout, action)
    ..subjectNicks = _subjectNicksReducer(state.subjectNicks, action)
    ..scrollToSubjectNicks =
        _scrollToSubjectNicksReducer(state.scrollToSubjectNicks, action)
    ..showCalendarNicksBar =
        _showCalendarNicksBarReducer(state.showCalendarNicksBar, action)
    ..showGradesDiagram =
        _showGradesDiagramReducer(state.showGradesDiagram, action)
    ..showAllSubjectsAverage =
        _showAllSubjectsAverageReducer(state.showAllSubjectsAverage, action));
}

final _askWhenDeleteReducer =
    TypedReducer((bool ask, SetAskWhenDeleteAction action) => action.ask);
final _showCancelledReducer = TypedReducer(
    (bool showCancelled, SetGradesShowCancelledAction action) =>
        action.showCancelled);
final _sortByTypeReducer = TypedReducer(
    (bool typeSorted, SetGradesTypeSortedAction action) => action.typeSorted);
final _saveDataReducer =
    TypedReducer((bool safeMode, SetSaveNoDataAction action) => action.noSave);
final _savePassReducer =
    TypedReducer((bool safeMode, SetSaveNoPassAction action) => action.noSave);
final _offlineEnabledReducer = TypedReducer(
    (bool safeMode, SetOfflineEnabledAction action) => action.enable);
final _deleteOnLogout = TypedReducer(
    (bool delete, SetDeleteDataOnLogoutAction action) => action.delete);
final _subjectNicksReducer = TypedReducer(
    (MapBuilder<String, String> nicks, SetSubjectNicksAction action) =>
        MapBuilder<String, String>(action.subjectNicks));
final _scrollToSubjectNicksReducer = combineReducers<bool>(
  [
    TypedReducer(
        (bool scrollToNicks, ShowEditCalendarSubjectNicksAction action) =>
            true),
    TypedReducer((bool scrollToNicks, ShowSettingsAction action) => false),
  ],
);
final _showCalendarNicksBarReducer = TypedReducer(
    (bool show, SetShowCalendarSubjectNicksBarAction action) => action.show);
final _showGradesDiagramReducer =
    TypedReducer((bool show, SetShowGradesDiagramAction action) => action.show);
final _showAllSubjectsAverageReducer = TypedReducer(
    (bool show, SetShowAllSubjectsAverageAction action) => action.show);
