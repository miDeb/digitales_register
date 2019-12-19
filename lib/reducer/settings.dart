import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

import '../actions/grades_actions.dart';
import '../actions/routing_actions.dart';
import '../actions/settings_actions.dart';
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
        _showAllSubjectsAverageReducer(state.showAllSubjectsAverage, action)
    ..dashboardMarkNewOrChangedEntries =
        _dashboardMarkNewOrChangedEntriesReducer(
            state.dashboardMarkNewOrChangedEntries, action)
    ..graphConfigs = combineReducers<MapBuilder<int, SubjectGraphConfig>>(
      [
        _updateGradeGraphConfigsReducer,
        _setGradesGraphConfigReducer,
      ],
    )(state.graphConfigs, action));
}

final _askWhenDeleteReducer = TypedReducer(
    (bool ask, SetAskWhenDeleteReminderAction action) => action.ask);
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
    (bool safeMode, SetOfflineEnabledAction action) => action.enabled);
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
final _dashboardMarkNewOrChangedEntriesReducer = TypedReducer(
    (bool mark, SetDashboardMarkNewOrChangedEntriesAction action) =>
        action.mark);
final _setGradesGraphConfigReducer = TypedReducer(
    (MapBuilder<int, SubjectGraphConfig> state, SetGraphConfigsAction action) =>
        MapBuilder<int, SubjectGraphConfig>(action.configs));

final _colors = List.of(Colors.primaries)
  ..removeWhere((c) => _similarColors.contains(c));

final _similarColors = [
  Colors.lime,
  Colors.lightBlue,
  Colors.cyan,
  Colors.amber
];

const _defaultThick = 2;
final _updateGradeGraphConfigsReducer =
    TypedReducer<MapBuilder<int, SubjectGraphConfig>, UpdateGraphConfigsAction>(
        (graphConfigsBuilder, UpdateGraphConfigsAction action) {
  final state = graphConfigsBuilder.build();

  for (final entry in state.entries) {
    if (!action.subjects.any((s) => s.id == entry.key)) {
      graphConfigsBuilder.remove(entry);
    }
  }
  for (var subject in action.subjects) {
    if (!graphConfigsBuilder.build().containsKey(subject.id)) {
      graphConfigsBuilder.update(
        (b) => b
          ..[subject.id] = SubjectGraphConfig((b) => b
            ..thick = _defaultThick
            ..color = _colors
                .firstWhere(
                  (color) => !graphConfigsBuilder
                      .build()
                      .values
                      .any((config) => config.color == color.value),
                  orElse: () => _similarColors.firstWhere(
                    (color) => !graphConfigsBuilder
                        .build()
                        .values
                        .any((config) => config.color == color.value),
                    orElse: () => (List.of(Colors.primaries)..shuffle()).first,
                  ),
                )
                .value),
      );
    }
  }
  return graphConfigsBuilder;
});
