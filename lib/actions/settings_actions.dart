import 'package:built_collection/built_collection.dart';
import 'package:built_redux/built_redux.dart';

import '../app_state.dart';

part 'settings_actions.g.dart';

abstract class SettingsActions extends ReduxActions {
  factory SettingsActions() => _$SettingsActions();
  SettingsActions._();

  abstract final ActionDispatcher<bool> saveNoPass;
  abstract final ActionDispatcher<bool> offlineEnabled;
  abstract final ActionDispatcher<bool> saveNoData;
  abstract final ActionDispatcher<bool> deleteDataOnLogout;
  abstract final ActionDispatcher<BuiltMap<String, String>> subjectNicks;
  abstract final ActionDispatcher<BuiltList<String>> ignoreSubjectsForAverage;
  abstract final ActionDispatcher<MapEntry<String, SubjectTheme>> setSubjectTheme;
  abstract final ActionDispatcher<List<String>> updateSubjectThemes;
  abstract final ActionDispatcher<bool> askWhenDeleteReminder;
  abstract final ActionDispatcher<bool> gradesTypeSorted;
  abstract final ActionDispatcher<bool> showCancelledGrades;
  abstract final ActionDispatcher<bool> showGradesDiagram;
  abstract final ActionDispatcher<bool> showAllSubjectsAverage;
  abstract final ActionDispatcher<bool> markNotSeenDashboardEntries;
  abstract final ActionDispatcher<bool> deduplicateDashboardEntries;
  abstract final ActionDispatcher<bool> showCalendarSubjectNicksBar;
  abstract final ActionDispatcher<bool> drawerExpandedChange;
  abstract final ActionDispatcher<bool> dashboardColorBorders;
  abstract final ActionDispatcher<bool> dashboardColorTestsInRed;
}
