import 'package:built_collection/built_collection.dart';
import 'package:built_redux/built_redux.dart';
import 'package:flutter/material.dart' hide Action;

import '../actions/routing_actions.dart';
import '../actions/settings_actions.dart';
import '../app_state.dart';
import '../data.dart';

final settingsReducerBuilder = NestedReducerBuilder<AppState, AppStateBuilder,
    SettingsState, SettingsStateBuilder>(
  (s) => s.settingsState,
  (b) => b.settingsState,
)
  ..add(SettingsActionsNames.offlineEnabled, _offlineEnabled)
  ..add(SettingsActionsNames.saveNoData, _saveNoData)
  ..add(SettingsActionsNames.saveNoPass, _saveNoPass)
  ..add(SettingsActionsNames.askWhenDeleteReminder, _askWhenDeleteReminder)
  ..add(SettingsActionsNames.showCancelledGrades, _showCancelledGrades)
  ..add(SettingsActionsNames.gradesTypeSorted, _gradesTypeSorted)
  ..add(SettingsActionsNames.deleteDataOnLogout, _deleteDataOnLogout)
  ..add(SettingsActionsNames.subjectNicks, _subjectNicks)
  ..add(
      RoutingActionsNames.showEditCalendarSubjectNicks, _showEditCalendarNicks)
  ..add(RoutingActionsNames.showEditGradesAverageSettings,
      _showEditGradesAverageSettings)
  ..add(RoutingActionsNames.showSettings, _showSettings)
  ..add(SettingsActionsNames.showCalendarSubjectNicksBar, _calendarNicksBar)
  ..add(SettingsActionsNames.showGradesDiagram, _gradesChart)
  ..add(SettingsActionsNames.showAllSubjectsAverage, _allSubjectsAverage)
  ..add(
      SettingsActionsNames.ignoreSubjectsForAverage, _ignoreSubjectsForAverage)
  ..add(SettingsActionsNames.markNotSeenDashboardEntries,
      _markNotSeenDashboardEntries)
  ..add(SettingsActionsNames.deduplicateDashboardEntries,
      _deduplicateDashboardEntries)
  ..add(SettingsActionsNames.updateGraphConfig, _updateGradeGraphConfigs)
  ..add(SettingsActionsNames.setGraphConfig, _setGradeGraphConfig)
  ..add(SettingsActionsNames.drawerExpandedChange, _drawerFullyExpanded);

void _askWhenDeleteReminder(
    SettingsState state, Action<bool> action, SettingsStateBuilder builder) {
  builder.askWhenDelete = action.payload;
}

void _showCancelledGrades(
    SettingsState state, Action<bool> action, SettingsStateBuilder builder) {
  builder.showCancelled = action.payload;
}

void _gradesTypeSorted(
    SettingsState state, Action<bool> action, SettingsStateBuilder builder) {
  builder.typeSorted = action.payload;
}

void _saveNoData(
    SettingsState state, Action<bool> action, SettingsStateBuilder builder) {
  builder.noDataSaving = action.payload;
}

void _saveNoPass(
    SettingsState state, Action<bool> action, SettingsStateBuilder builder) {
  builder.noPasswordSaving = action.payload;
}

void _offlineEnabled(
    SettingsState state, Action<bool> action, SettingsStateBuilder builder) {
  builder.offlineEnabled = action.payload;
}

void _deleteDataOnLogout(
    SettingsState state, Action<bool> action, SettingsStateBuilder builder) {
  builder.deleteDataOnLogout = action.payload;
}

void _subjectNicks(SettingsState state, Action<BuiltMap<String, String>> action,
    SettingsStateBuilder builder) {
  builder.subjectNicks.replace(action.payload);
}

void _showEditCalendarNicks(
    SettingsState state, Action<void> action, SettingsStateBuilder builder) {
  builder
    ..scrollToSubjectNicks = true
    ..scrollToGrades = false;
}

void _showEditGradesAverageSettings(
    SettingsState state, Action<void> action, SettingsStateBuilder builder) {
  builder
    ..scrollToGrades = true
    ..scrollToSubjectNicks = false;
}

void _showSettings(
    SettingsState state, Action<void> action, SettingsStateBuilder builder) {
  builder
    ..scrollToSubjectNicks = false
    ..scrollToGrades = false;
}

void _calendarNicksBar(
    SettingsState state, Action<bool> action, SettingsStateBuilder builder) {
  builder.showCalendarNicksBar = action.payload;
}

void _gradesChart(
    SettingsState state, Action<bool> action, SettingsStateBuilder builder) {
  builder.showGradesDiagram = action.payload;
}

void _allSubjectsAverage(
    SettingsState state, Action<bool> action, SettingsStateBuilder builder) {
  builder.showAllSubjectsAverage = action.payload;
}

void _ignoreSubjectsForAverage(SettingsState state,
    Action<BuiltList<String>> action, SettingsStateBuilder builder) {
  builder.ignoreForGradesAverage.replace(action.payload);
}

void _setGradeGraphConfig(
    SettingsState state,
    Action<MapEntry<int, SubjectGraphConfig>> action,
    SettingsStateBuilder builder) {
  builder.graphConfigs[action.payload.key] = action.payload.value;
}

void _markNotSeenDashboardEntries(
    SettingsState state, Action<bool> action, SettingsStateBuilder builder) {
  builder.dashboardMarkNewOrChangedEntries = action.payload;
}

void _deduplicateDashboardEntries(
    SettingsState state, Action<bool> action, SettingsStateBuilder builder) {
  builder.dashboardDeduplicateEntries = action.payload;
}

void _drawerFullyExpanded(
    SettingsState state, Action<bool> action, SettingsStateBuilder builder) {
  builder.drawerFullyExpanded = action.payload;
}

void _updateGradeGraphConfigs(SettingsState state,
    Action<BuiltList<Subject>> action, SettingsStateBuilder builder) {
  for (final entry in state.graphConfigs.entries) {
    if (!action.payload.any((s) => s.id == entry.key)) {
      builder.graphConfigs.remove(entry);
    }
  }
  for (var subject in action.payload) {
    if (!builder.graphConfigs.build().containsKey(subject.id)) {
      builder.graphConfigs.update(
        (b) => b
          ..[subject.id] = SubjectGraphConfig((b) => b
            ..thick = _defaultThick
            ..color = _colors
                .firstWhere(
                  (color) => !builder.graphConfigs
                      .build()
                      .values
                      .any((config) => config.color == color.value),
                  orElse: () => _similarColors.firstWhere(
                    (color) => !builder.graphConfigs
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
}

final _colors = List.of(Colors.primaries)
  ..removeWhere((c) => _similarColors.contains(c));

final _similarColors = [
  Colors.lime,
  Colors.lightBlue,
  Colors.cyan,
  Colors.amber
];

const _defaultThick = 2;
