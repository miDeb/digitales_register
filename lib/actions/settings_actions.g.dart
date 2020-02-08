// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_actions.dart';

// **************************************************************************
// BuiltReduxGenerator
// **************************************************************************

// ignore_for_file: avoid_classes_with_only_static_members
// ignore_for_file: annotate_overrides
// ignore_for_file: overridden_fields
// ignore_for_file: type_annotate_public_apis

class _$SettingsActions extends SettingsActions {
  factory _$SettingsActions() => _$SettingsActions._();
  _$SettingsActions._() : super._();

  final saveNoPass = ActionDispatcher<bool>('SettingsActions-saveNoPass');
  final offlineEnabled = ActionDispatcher<bool>('SettingsActions-offlineEnabled');
  final saveNoData = ActionDispatcher<bool>('SettingsActions-saveNoData');
  final deleteDataOnLogout = ActionDispatcher<bool>('SettingsActions-deleteDataOnLogout');
  final subjectNicks = ActionDispatcher<BuiltMap<String, String>>('SettingsActions-subjectNicks');
  final setGraphConfig =
      ActionDispatcher<MapEntry<int, SubjectGraphConfig>>('SettingsActions-setGraphConfig');
  final updateGraphConfig =
      ActionDispatcher<BuiltList<Subject>>('SettingsActions-updateGraphConfig');
  final askWhenDeleteReminder = ActionDispatcher<bool>('SettingsActions-askWhenDeleteReminder');
  final gradesTypeSorted = ActionDispatcher<bool>('SettingsActions-gradesTypeSorted');
  final showCancelledGrades = ActionDispatcher<bool>('SettingsActions-showCancelledGrades');
  final showGradesDiagram = ActionDispatcher<bool>('SettingsActions-showGradesDiagram');
  final showAllSubjectsAverage = ActionDispatcher<bool>('SettingsActions-showAllSubjectsAverage');
  final markNotSeenDashboardEntries =
      ActionDispatcher<bool>('SettingsActions-markNotSeenDashboardEntries');
  final showCalendarSubjectNicksBar =
      ActionDispatcher<bool>('SettingsActions-showCalendarSubjectNicksBar');

  @override
  void setDispatcher(Dispatcher dispatcher) {
    saveNoPass.setDispatcher(dispatcher);
    offlineEnabled.setDispatcher(dispatcher);
    saveNoData.setDispatcher(dispatcher);
    deleteDataOnLogout.setDispatcher(dispatcher);
    subjectNicks.setDispatcher(dispatcher);
    setGraphConfig.setDispatcher(dispatcher);
    updateGraphConfig.setDispatcher(dispatcher);
    askWhenDeleteReminder.setDispatcher(dispatcher);
    gradesTypeSorted.setDispatcher(dispatcher);
    showCancelledGrades.setDispatcher(dispatcher);
    showGradesDiagram.setDispatcher(dispatcher);
    showAllSubjectsAverage.setDispatcher(dispatcher);
    markNotSeenDashboardEntries.setDispatcher(dispatcher);
    showCalendarSubjectNicksBar.setDispatcher(dispatcher);
  }
}

class SettingsActionsNames {
  static final saveNoPass = ActionName<bool>('SettingsActions-saveNoPass');
  static final offlineEnabled = ActionName<bool>('SettingsActions-offlineEnabled');
  static final saveNoData = ActionName<bool>('SettingsActions-saveNoData');
  static final deleteDataOnLogout = ActionName<bool>('SettingsActions-deleteDataOnLogout');
  static final subjectNicks = ActionName<BuiltMap<String, String>>('SettingsActions-subjectNicks');
  static final setGraphConfig =
      ActionName<MapEntry<int, SubjectGraphConfig>>('SettingsActions-setGraphConfig');
  static final updateGraphConfig =
      ActionName<BuiltList<Subject>>('SettingsActions-updateGraphConfig');
  static final askWhenDeleteReminder = ActionName<bool>('SettingsActions-askWhenDeleteReminder');
  static final gradesTypeSorted = ActionName<bool>('SettingsActions-gradesTypeSorted');
  static final showCancelledGrades = ActionName<bool>('SettingsActions-showCancelledGrades');
  static final showGradesDiagram = ActionName<bool>('SettingsActions-showGradesDiagram');
  static final showAllSubjectsAverage = ActionName<bool>('SettingsActions-showAllSubjectsAverage');
  static final markNotSeenDashboardEntries =
      ActionName<bool>('SettingsActions-markNotSeenDashboardEntries');
  static final showCalendarSubjectNicksBar =
      ActionName<bool>('SettingsActions-showCalendarSubjectNicksBar');
}
