import 'package:built_value/built_value.dart';

part 'calendar_actions.g.dart';

abstract class LoadCalendarAction
    implements Built<LoadCalendarAction, LoadCalendarActionBuilder> {
  LoadCalendarAction._();
  factory LoadCalendarAction(
          [void Function(LoadCalendarActionBuilder) updates]) =
      _$LoadCalendarAction;

  DateTime get startDate;
}

abstract class CalendarLoadedAction
    implements Built<CalendarLoadedAction, CalendarLoadedActionBuilder> {
  CalendarLoadedAction._();
  factory CalendarLoadedAction(
          [void Function(CalendarLoadedActionBuilder) updates]) =
      _$CalendarLoadedAction;

  Object get result;
}

abstract class SetCalendarCurrentMondayAction
    implements
        Built<SetCalendarCurrentMondayAction,
            SetCalendarCurrentMondayActionBuilder> {
  SetCalendarCurrentMondayAction._();
  factory SetCalendarCurrentMondayAction(
          [void Function(SetCalendarCurrentMondayActionBuilder) updates]) =
      _$SetCalendarCurrentMondayAction;

  DateTime get monday;
}
