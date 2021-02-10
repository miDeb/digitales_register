import 'package:built_redux/built_redux.dart';

part 'calendar_actions.g.dart';

abstract class CalendarActions extends ReduxActions {
  factory CalendarActions() => _$CalendarActions();
  CalendarActions._();

  abstract final ActionDispatcher<DateTime> load;
  abstract final ActionDispatcher<Map<String, dynamic>> loaded;
  abstract final ActionDispatcher<DateTime> setCurrentMonday;
}
