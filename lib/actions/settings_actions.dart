import 'package:built_collection/built_collection.dart';
import 'package:built_redux/built_redux.dart';

import '../app_state.dart';
import '../data.dart';

part 'settings_actions.g.dart';

abstract class SettingsActions extends ReduxActions {
  SettingsActions._();
  factory SettingsActions() => _$SettingsActions();

  ActionDispatcher<bool> saveNoPass;
  ActionDispatcher<bool> offlineEnabled;
  ActionDispatcher<bool> saveNoData;
  ActionDispatcher<bool> deleteDataOnLogout;
  ActionDispatcher<BuiltMap<String, String>> subjectNicks;
  ActionDispatcher<MapEntry<int, SubjectGraphConfig>> setGraphConfig;
  ActionDispatcher<BuiltList<Subject>> updateGraphConfig;
  ActionDispatcher<bool> askWhenDeleteReminder;
  ActionDispatcher<bool> gradesTypeSorted;
  ActionDispatcher<bool> showCancelledGrades;
  ActionDispatcher<bool> showGradesDiagram;
  ActionDispatcher<bool> showAllSubjectsAverage;
  ActionDispatcher<bool> markNotSeenDashboardEntries;
  ActionDispatcher<bool> deduplicateDashboardEntries;
  ActionDispatcher<bool> showCalendarSubjectNicksBar;
  ActionDispatcher<bool> drawerExpandedChange;
}
