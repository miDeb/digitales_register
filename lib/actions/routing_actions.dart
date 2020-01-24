import 'package:built_redux/built_redux.dart';

part 'routing_actions.g.dart';

abstract class RoutingActions extends ReduxActions {
  RoutingActions._();
  factory RoutingActions() => _$RoutingActions();

  ActionDispatcher<void> showLogin;
  ActionDispatcher<void> showAbsences;
  ActionDispatcher<void> showNotifications;
  ActionDispatcher<void> showSettings;
  ActionDispatcher<void> showGrades;
  ActionDispatcher<void> showGradesChart;
  ActionDispatcher<void> showCalendar;
  ActionDispatcher<void> showEditCalendarSubjectNicks;
}
