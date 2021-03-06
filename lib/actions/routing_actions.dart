import 'package:built_redux/built_redux.dart';
import 'package:built_value/built_value.dart';

part 'routing_actions.g.dart';

abstract class RoutingActions extends ReduxActions {
  factory RoutingActions() => _$RoutingActions();
  RoutingActions._();

  abstract final VoidActionDispatcher showLogin;
  abstract final VoidActionDispatcher showProfile;
  abstract final VoidActionDispatcher showChangeEmail;
  abstract final ActionDispatcher<String> showRequestPassReset;
  abstract final ActionDispatcher<ShowPassResetPayload> showPassReset;
  abstract final VoidActionDispatcher showAbsences;
  abstract final VoidActionDispatcher showNotifications;
  abstract final VoidActionDispatcher showSettings;
  abstract final VoidActionDispatcher showGrades;
  abstract final VoidActionDispatcher showGradesChart;
  abstract final VoidActionDispatcher showGradeCalculator;
  abstract final VoidActionDispatcher showCalendar;
  abstract final VoidActionDispatcher showCertificate;
  abstract final VoidActionDispatcher showMessages;
  abstract final ActionDispatcher<int> showMessage;
  abstract final VoidActionDispatcher showEditCalendarSubjectNicks;
  abstract final VoidActionDispatcher showEditGradesAverageSettings;
}

abstract class ShowPassResetPayload
    implements Built<ShowPassResetPayload, ShowPassResetPayloadBuilder> {
  factory ShowPassResetPayload(
          [void Function(ShowPassResetPayloadBuilder)? updates]) =
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
