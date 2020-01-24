import 'package:built_collection/built_collection.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_built_redux/flutter_built_redux.dart';

import '../actions/app_actions.dart';
import '../app_state.dart';
import '../ui/settings_page_widget.dart';

class SettingsPageContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnection<AppState, AppActions, SettingsViewModel>(
      builder: (context, vm, actions) {
        return SettingsPageWidget(
          vm: vm,
          onSetDarkMode: (dm) {
            DynamicTheme.of(context).setBrightness(
              Theme.of(context).brightness == Brightness.dark ? Brightness.light : Brightness.dark,
            );
          },
          onSetNoPassSaving: actions.settingsActions.saveNoPass,
          onSetNoDataSaving: actions.settingsActions.saveNoData,
          onSetAskWhenDelete: actions.settingsActions.askWhenDeleteReminder,
          onSetDeleteDataOnLogout: actions.settingsActions.deleteDataOnLogout,
          onSetOfflineEnabled: actions.settingsActions.offlineEnabled,
          onSetSubjectNicks: (map) => actions.settingsActions.subjectNicks(BuiltMap(map)),
          onSetShowCalendarEditNicksBar: actions.settingsActions.showCalendarSubjectNicksBar,
          onSetShowGradesDiagram: actions.settingsActions.showGradesDiagram,
          onSetShowAllSubjectsAverage: actions.settingsActions.showAllSubjectsAverage,
          onSetDashboardMarkNewOrChangedEntries:
              actions.settingsActions.markNotSeenDashboardEntries,
        );
      },
      connect: (state) {
        return SettingsViewModel(state);
      },
    );
  }
}

typedef OnSettingChanged<T> = void Function(T newValue);

class SettingsViewModel {
  final Map<String, String> subjectNicks;
  final bool noPassSaving;
  final bool noDataSaving;
  final bool askWhenDelete;
  final bool deleteDataOnLogout;
  final bool offlineEnabled;
  final bool showCalendarEditNicksBar;
  final bool showGradesDiagram;
  final bool showAllSubjectsAverage;
  final bool dashboardMarkNewOrChangedEntries;
  final bool showSubjectNicks;
  final List<String> allSubjects;
  SettingsViewModel(AppState state)
      : noPassSaving = state.settingsState.noPasswordSaving,
        noDataSaving = state.settingsState.noDataSaving,
        askWhenDelete = state.settingsState.askWhenDelete,
        deleteDataOnLogout = state.settingsState.deleteDataOnLogout,
        offlineEnabled = state.settingsState.offlineEnabled,
        subjectNicks = state.settingsState.subjectNicks.toMap(),
        showSubjectNicks = state.settingsState.scrollToSubjectNicks,
        showCalendarEditNicksBar = state.settingsState.showCalendarNicksBar,
        showGradesDiagram = state.settingsState.showGradesDiagram,
        showAllSubjectsAverage = state.settingsState.showAllSubjectsAverage,
        dashboardMarkNewOrChangedEntries = state.settingsState.dashboardMarkNewOrChangedEntries,
        allSubjects = extractAllSubjects(state);

  static List<String> extractAllSubjects(AppState appState) {
    final subjects = <String>[];
    for (final day in appState.calendarState.days.values) {
      for (final hour in day.hours) {
        if (!subjects.contains(hour.subject)) subjects.add(hour.subject);
      }
    }
    for (final subject in appState.gradesState.subjects) {
      if (!subjects.contains(subject.name)) subjects.add(subject.name);
    }
    for (final day in appState.dashboardState.allDays) {
      for (final homework in day.homework) {
        if (homework.label != null && !subjects.contains(homework.label))
          subjects.add(homework.label);
      }
    }
    subjects.removeWhere(
      (subject) => appState.settingsState.subjectNicks.containsKey(subject),
    );
    return subjects;
  }
}
