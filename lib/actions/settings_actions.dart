import 'package:built_value/built_value.dart';
import 'package:built_collection/built_collection.dart';

import '../app_state.dart';
part 'settings_actions.g.dart';

abstract class SetSaveNoPassAction
    implements Built<SetSaveNoPassAction, SetSaveNoPassActionBuilder> {
  SetSaveNoPassAction._();
  factory SetSaveNoPassAction(
          [void Function(SetSaveNoPassActionBuilder) updates]) =
      _$SetSaveNoPassAction;

  bool get noSave;
}

abstract class SetOfflineEnabledAction
    implements Built<SetOfflineEnabledAction, SetOfflineEnabledActionBuilder> {
  SetOfflineEnabledAction._();
  factory SetOfflineEnabledAction(
          [void Function(SetOfflineEnabledActionBuilder) updates]) =
      _$SetOfflineEnabledAction;

  bool get enabled;
}

abstract class SetSaveNoDataAction
    implements Built<SetSaveNoDataAction, SetSaveNoDataActionBuilder> {
  SetSaveNoDataAction._();
  factory SetSaveNoDataAction(
          [void Function(SetSaveNoDataActionBuilder) updates]) =
      _$SetSaveNoDataAction;

  bool get noSave;
}

abstract class SetDeleteDataOnLogoutAction
    implements
        Built<SetDeleteDataOnLogoutAction, SetDeleteDataOnLogoutActionBuilder> {
  SetDeleteDataOnLogoutAction._();
  factory SetDeleteDataOnLogoutAction(
          [void Function(SetDeleteDataOnLogoutActionBuilder) updates]) =
      _$SetDeleteDataOnLogoutAction;

  bool get delete;
}

abstract class SetSubjectNicksAction
    implements Built<SetSubjectNicksAction, SetSubjectNicksActionBuilder> {
  SetSubjectNicksAction._();
  factory SetSubjectNicksAction(
          [void Function(SetSubjectNicksActionBuilder) updates]) =
      _$SetSubjectNicksAction;

  BuiltMap<String, String> get subjectNicks;
}

abstract class SetGraphConfigsAction
    implements Built<SetGraphConfigsAction, SetGraphConfigsActionBuilder> {
  SetGraphConfigsAction._();
  factory SetGraphConfigsAction(
          [void Function(SetGraphConfigsActionBuilder) updates]) =
      _$SetGraphConfigsAction;

  BuiltMap<int, SubjectGraphConfig> get configs;
}

abstract class SetAskWhenDeleteReminderAction
    implements
        Built<SetAskWhenDeleteReminderAction,
            SetAskWhenDeleteReminderActionBuilder> {
  SetAskWhenDeleteReminderAction._();
  factory SetAskWhenDeleteReminderAction(
          [void Function(SetAskWhenDeleteReminderActionBuilder) updates]) =
      _$SetAskWhenDeleteReminderAction;

  bool get ask;
}

abstract class SetGradesTypeSortedAction
    implements
        Built<SetGradesTypeSortedAction, SetGradesTypeSortedActionBuilder> {
  SetGradesTypeSortedAction._();
  factory SetGradesTypeSortedAction(
          [void Function(SetGradesTypeSortedActionBuilder) updates]) =
      _$SetGradesTypeSortedAction;

  bool get typeSorted;
}

abstract class SetGradesShowCancelledAction
    implements
        Built<SetGradesShowCancelledAction,
            SetGradesShowCancelledActionBuilder> {
  SetGradesShowCancelledAction._();
  factory SetGradesShowCancelledAction(
          [void Function(SetGradesShowCancelledActionBuilder) updates]) =
      _$SetGradesShowCancelledAction;

  bool get showCancelled;
}

abstract class SetShowCalendarSubjectNicksBarAction
    implements
        Built<SetShowCalendarSubjectNicksBarAction,
            SetShowCalendarSubjectNicksBarActionBuilder> {
  SetShowCalendarSubjectNicksBarAction._();
  factory SetShowCalendarSubjectNicksBarAction(
      [void Function(SetShowCalendarSubjectNicksBarActionBuilder)
          updates]) = _$SetShowCalendarSubjectNicksBarAction;

  bool get show;
}

abstract class SetShowGradesDiagramAction
    implements
        Built<SetShowGradesDiagramAction, SetShowGradesDiagramActionBuilder> {
  SetShowGradesDiagramAction._();
  factory SetShowGradesDiagramAction(
          [void Function(SetShowGradesDiagramActionBuilder) updates]) =
      _$SetShowGradesDiagramAction;

  bool get show;
}

abstract class SetShowAllSubjectsAverageAction
    implements
        Built<SetShowAllSubjectsAverageAction,
            SetShowAllSubjectsAverageActionBuilder> {
  SetShowAllSubjectsAverageAction._();
  factory SetShowAllSubjectsAverageAction(
          [void Function(SetShowAllSubjectsAverageActionBuilder) updates]) =
      _$SetShowAllSubjectsAverageAction;

  bool get show;
}

abstract class SetDashboardMarkNewOrChangedEntriesAction
    implements
        Built<SetDashboardMarkNewOrChangedEntriesAction,
            SetDashboardMarkNewOrChangedEntriesActionBuilder> {
  SetDashboardMarkNewOrChangedEntriesAction._();
  factory SetDashboardMarkNewOrChangedEntriesAction(
      [void Function(SetDashboardMarkNewOrChangedEntriesActionBuilder)
          updates]) = _$SetDashboardMarkNewOrChangedEntriesAction;

  bool get mark;
}
