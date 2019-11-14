import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../actions.dart';
import '../app_state.dart';
import '../ui/settings_page_widget.dart';

class SettingsPageContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, SettingsViewModel>(
      builder: (BuildContext context, SettingsViewModel vm) {
        return SettingsPageWidget(vm: vm);
      },
      converter: (Store<AppState> store) {
        return SettingsViewModel.fromStore(
          store,
          (dm) {
            DynamicTheme.of(context).setBrightness(
                Theme.of(context).brightness == Brightness.dark
                    ? Brightness.light
                    : Brightness.dark);
          },
        );
      },
    );
  }
}

typedef void OnSettingChanged<T>(T newValue);

class SettingsViewModel {
  final OnSettingChanged<bool> onSetNoPassSaving;
  final bool noPassSaving;
  final OnSettingChanged<bool> onSetNoDataSaving;
  final bool noDataSaving;
  final OnSettingChanged<bool> onSetDarkMode;
  final OnSettingChanged<bool> onSetAskWhenDelete;
  final bool askWhenDelete;
  final OnSettingChanged<bool> onSetDeleteDataOnLogout;
  final bool deleteDataOnLogout;
  final OnSettingChanged<bool> onSetOfflineEnabled;
  final bool offlineEnabled;
  final OnSettingChanged<Map<String, String>> onSetSubjectNicks;
  final Map<String, String> subjectNicks;
  final OnSettingChanged<bool> onSetShowCalendarEditNicksBar;
  final bool showCalendarEditNicksBar;
  final OnSettingChanged<bool> onSetShowGradesDiagram;
  final bool showGradesDiagram;
  final OnSettingChanged<bool> onSetShowAllSubjectsAverage;
  final bool showAllSubjectsAverage;
  final bool showSubjectNicks;
  final List<String> allSubjects;
  SettingsViewModel.fromStore(Store<AppState> store, this.onSetDarkMode)
      : noPassSaving = store.state.settingsState.noPasswordSaving,
        noDataSaving = store.state.settingsState.noDataSaving,
        askWhenDelete = store.state.settingsState.askWhenDelete,
        deleteDataOnLogout = store.state.settingsState.deleteDataOnLogout,
        offlineEnabled = store.state.settingsState.offlineEnabled,
        subjectNicks = store.state.settingsState.subjectNicks.toMap(),
        showSubjectNicks = store.state.settingsState.scrollToSubjectNicks,
        showCalendarEditNicksBar =
            store.state.settingsState.showCalendarNicksBar,
        showGradesDiagram = store.state.settingsState.showGradesDiagram,
        showAllSubjectsAverage =
            store.state.settingsState.showAllSubjectsAverage,
        allSubjects = extractAllSubjects(store.state),
        onSetNoPassSaving = ((bool mode) {
          store.dispatch(SetSaveNoPassAction(mode));
        }),
        onSetNoDataSaving = ((bool mode) {
          store.dispatch(SetSaveNoDataAction(mode));
        }),
        onSetAskWhenDelete = ((bool mode) {
          store.dispatch(SetAskWhenDeleteAction(mode));
        }),
        onSetDeleteDataOnLogout = ((bool mode) {
          store.dispatch(SetDeleteDataOnLogoutAction(mode));
        }),
        onSetOfflineEnabled = ((bool mode) {
          store.dispatch(SetOfflineEnabledAction(mode));
        }),
        onSetSubjectNicks = ((Map<String, String> nicks) {
          store.dispatch(SetSubjectNicksAction(nicks));
        }),
        onSetShowCalendarEditNicksBar = ((bool mode) {
          store.dispatch(SetShowCalendarSubjectNicksBarAction(mode));
        }),
        onSetShowGradesDiagram = ((bool mode) {
          store.dispatch(SetShowGradesDiagramAction(mode));
        }),
        onSetShowAllSubjectsAverage = ((bool mode) {
          store.dispatch(SetShowAllSubjectsAverageAction(mode));
        });

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
    for (final day in appState.dayState.allDays) {
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
