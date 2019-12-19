import 'package:built_value/built_value.dart';

part 'routing_actions.g.dart';

abstract class ShowLoginAction
    implements Built<ShowLoginAction, ShowLoginActionBuilder> {
  ShowLoginAction._();
  factory ShowLoginAction([void Function(ShowLoginActionBuilder) updates]) =
      _$ShowLoginAction;
}

abstract class ShowAbsencesAction
    implements Built<ShowAbsencesAction, ShowAbsencesActionBuilder> {
  ShowAbsencesAction._();
  factory ShowAbsencesAction(
          [void Function(ShowAbsencesActionBuilder) updates]) =
      _$ShowAbsencesAction;
}

abstract class ShowNotificationsAction
    implements Built<ShowNotificationsAction, ShowNotificationsActionBuilder> {
  ShowNotificationsAction._();
  factory ShowNotificationsAction(
          [void Function(ShowNotificationsActionBuilder) updates]) =
      _$ShowNotificationsAction;
}

abstract class ShowSettingsAction
    implements Built<ShowSettingsAction, ShowSettingsActionBuilder> {
  ShowSettingsAction._();
  factory ShowSettingsAction(
          [void Function(ShowSettingsActionBuilder) updates]) =
      _$ShowSettingsAction;
}

abstract class ShowGradesAction
    implements Built<ShowGradesAction, ShowGradesActionBuilder> {
  ShowGradesAction._();
  factory ShowGradesAction([void Function(ShowGradesActionBuilder) updates]) =
      _$ShowGradesAction;
}

abstract class ShowFullscreenChartAction
    implements
        Built<ShowFullscreenChartAction, ShowFullscreenChartActionBuilder> {
  ShowFullscreenChartAction._();
  factory ShowFullscreenChartAction(
          [void Function(ShowFullscreenChartActionBuilder) updates]) =
      _$ShowFullscreenChartAction;
}

abstract class ShowCalendarAction
    implements Built<ShowCalendarAction, ShowCalendarActionBuilder> {
  ShowCalendarAction._();
  factory ShowCalendarAction(
          [void Function(ShowCalendarActionBuilder) updates]) =
      _$ShowCalendarAction;
}

abstract class ShowEditCalendarSubjectNicksAction
    implements
        Built<ShowEditCalendarSubjectNicksAction,
            ShowEditCalendarSubjectNicksActionBuilder> {
  ShowEditCalendarSubjectNicksAction._();
  factory ShowEditCalendarSubjectNicksAction(
          [void Function(ShowEditCalendarSubjectNicksActionBuilder) updates]) =
      _$ShowEditCalendarSubjectNicksAction;
}
