import 'package:built_redux/built_redux.dart';

part 'calendar_actions.g.dart';

abstract class CalendarActions extends ReduxActions {
  factory CalendarActions() => _$CalendarActions();
  CalendarActions._();

  ActionDispatcher<DateTime> load;
  ActionDispatcher<Map<String, dynamic>> loaded;
  ActionDispatcher<DateTime> setCurrentMonday;
}
