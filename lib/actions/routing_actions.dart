import 'package:built_redux/built_redux.dart';
import 'package:built_value/built_value.dart';

part 'routing_actions.g.dart';

abstract class RoutingActions extends ReduxActions {
  factory RoutingActions() => _$RoutingActions();
  RoutingActions._();

  VoidActionDispatcher showLogin;
  VoidActionDispatcher showProfile;
  VoidActionDispatcher showChangeEmail;
  VoidActionDispatcher showRequestPassReset;
  ActionDispatcher<ShowPassResetPayload> showPassReset;
  VoidActionDispatcher showAbsences;
  VoidActionDispatcher showNotifications;
  VoidActionDispatcher showSettings;
  VoidActionDispatcher showGrades;
  VoidActionDispatcher showGradesChart;
  VoidActionDispatcher showCalendar;
  VoidActionDispatcher showCertificate;
  VoidActionDispatcher showMessages;
  ActionDispatcher<int> showMessage;
  VoidActionDispatcher showEditCalendarSubjectNicks;
  VoidActionDispatcher showEditGradesAverageSettings;
}

abstract class ShowPassResetPayload
    implements Built<ShowPassResetPayload, ShowPassResetPayloadBuilder> {
  factory ShowPassResetPayload(
          [void Function(ShowPassResetPayloadBuilder) updates]) =
      _$ShowPassResetPayload;
  ShowPassResetPayload._();

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
