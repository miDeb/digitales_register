import 'package:built_redux/built_redux.dart';

part 'calendar_actions.g.dart';

abstract class CalendarActions extends ReduxActions {
  CalendarActions._();
  factory CalendarActions() => new _$CalendarActions();

  ActionDispatcher<DateTime> load;
  ActionDispatcher<dynamic> loaded;
  ActionDispatcher<DateTime> setCurrentMonday;
}
