import 'package:built_redux/built_redux.dart';
import 'package:built_value/built_value.dart';

part 'routing_actions.g.dart';

abstract class RoutingActions extends ReduxActions {
  RoutingActions._();
  factory RoutingActions() => _$RoutingActions();

  ActionDispatcher<void> showLogin;
  ActionDispatcher<void> showRequestPassReset;
  ActionDispatcher<ShowPassResetPayload> showPassReset;
  ActionDispatcher<void> showAbsences;
  ActionDispatcher<void> showNotifications;
  ActionDispatcher<void> showSettings;
  ActionDispatcher<void> showGrades;
  ActionDispatcher<void> showGradesChart;
  ActionDispatcher<void> showCalendar;
  ActionDispatcher<void> showCertificate;
  ActionDispatcher<void> showEditCalendarSubjectNicks;
}

abstract class ShowPassResetPayload
    implements Built<ShowPassResetPayload, ShowPassResetPayloadBuilder> {
  ShowPassResetPayload._();
  factory ShowPassResetPayload(
          [void Function(ShowPassResetPayloadBuilder) updates]) =
      _$ShowPassResetPayload;

  String get token;
  String get email;

  @override
  String toString() {
    return (newBuiltValueToStringHelper('ShowPassResetPayload')
          //..add('token', token) // do not include the token
          ..add('email', email))
        .toString();
  }
}
