// Copyright (C) 2021 Michael Debertol
//
// This file is part of digitales_register.
//
// digitales_register is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// digitales_register is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with digitales_register.  If not, see <http://www.gnu.org/licenses/>.

import 'package:built_collection/built_collection.dart';
import 'package:built_redux/built_redux.dart';
import 'package:dr/actions/routing_actions.dart';
import 'package:dr/actions/settings_actions.dart';
import 'package:dr/app_state.dart';
import 'package:flutter/material.dart' hide Action;

final settingsReducerBuilder = NestedReducerBuilder<AppState, AppStateBuilder,
    SettingsState, SettingsStateBuilder>(
  (s) => s.settingsState,
  (b) => b.settingsState,
)
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
  ..add(SettingsActionsNames.updateSubjectThemes, _updateSubjectThemes)
  ..add(SettingsActionsNames.setSubjectTheme, _setSubjectTheme)
  ..add(SettingsActionsNames.drawerExpandedChange, _drawerFullyExpanded)
  ..add(SettingsActionsNames.dashboardColorBorders, _dashboardColorBorders)
  ..add(
      SettingsActionsNames.dashboardColorTestsInRed, _dashboardColorTestsInRed);

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

void _deleteDataOnLogout(
    SettingsState state, Action<bool> action, SettingsStateBuilder builder) {
  builder.deleteDataOnLogout = action.payload;
}

void _subjectNicks(SettingsState? state,
    Action<BuiltMap<String, String>> action, SettingsStateBuilder builder) {
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

void _ignoreSubjectsForAverage(SettingsState? state,
    Action<BuiltList<String>> action, SettingsStateBuilder builder) {
  builder.ignoreForGradesAverage.replace(action.payload);
}

void _setSubjectTheme(
    SettingsState state,
    Action<MapEntry<String, SubjectTheme>> action,
    SettingsStateBuilder builder) {
  builder.subjectThemes[action.payload.key] = action.payload.value;
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

void _dashboardColorBorders(
    SettingsState state, Action<bool> action, SettingsStateBuilder builder) {
  builder.dashboardColorBorders = action.payload;
}

void _dashboardColorTestsInRed(
    SettingsState state, Action<bool> action, SettingsStateBuilder builder) {
  builder.dashboardColorTestsInRed = action.payload;
}

void _updateSubjectThemes(SettingsState? state, Action<List<String>> action,
    SettingsStateBuilder builder) {
  for (final subject in action.payload) {
    if (!builder.subjectThemes.build().containsKey(subject)) {
      builder.subjectThemes.update(
        (b) => b
          ..[subject] = SubjectTheme((b) => b
            ..thick = _defaultThick
            ..color = _colors
                .firstWhere(
                  (color) => !builder.subjectThemes
                      .build()
                      .values
                      .any((config) => config.color == color.value),
                  orElse: () => _similarColors.firstWhere(
                    (color) => !builder.subjectThemes
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
