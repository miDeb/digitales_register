import 'package:built_collection/built_collection.dart';
import 'package:built_redux/built_redux.dart';

import '../app_state.dart';

part 'settings_actions.g.dart';

abstract class SettingsActions extends ReduxActions {
  factory SettingsActions() => _$SettingsActions();
  SettingsActions._();

  ActionDispatcher<bool> saveNoPass;
  ActionDispatcher<bool> offlineEnabled;
  ActionDispatcher<bool> saveNoData;
  ActionDispatcher<bool> deleteDataOnLogout;
  ActionDispatcher<BuiltMap<String, String>> subjectNicks;
  ActionDispatcher<BuiltList<String>> ignoreSubjectsForAverage;
  ActionDispatcher<MapEntry<String, SubjectTheme>> setSubjectTheme;
  ActionDispatcher<List<String>> updateSubjectThemes;
  ActionDispatcher<bool> askWhenDeleteReminder;
  ActionDispatcher<bool> gradesTypeSorted;
  ActionDispatcher<bool> showCancelledGrades;
  ActionDispatcher<bool> showGradesDiagram;
  ActionDispatcher<bool> showAllSubjectsAverage;
  ActionDispatcher<bool> markNotSeenDashboardEntries;
  ActionDispatcher<bool> deduplicateDashboardEntries;
  ActionDispatcher<bool> showCalendarSubjectNicksBar;
  ActionDispatcher<bool> drawerExpandedChange;
  ActionDispatcher<bool> dashboardColorBorders;
  ActionDispatcher<bool> dashboardColorTestsInRed;
}
