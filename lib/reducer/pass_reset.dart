import 'package:built_redux/built_redux.dart';

import '../actions/login_actions.dart';
import '../actions/routing_actions.dart';
import '../app_state.dart';

final resetPassReducerBuilder = NestedReducerBuilder<LoginState,
    LoginStateBuilder, ResetPassState, ResetPassStateBuilder>(
  (s) => s.resetPassState,
  (b) => b.resetPassState,
)
  ..add(RoutingActionsNames.showRequestPassReset, _showRequest)
  ..add(RoutingActionsNames.showPassReset, _showReset)
  ..add(LoginActionsNames.passResetFailed, _failed)
  ..add(LoginActionsNames.passResetSucceeded, _succeeded);

void _failed(ResetPassState state, Action<String> action,
    ResetPassStateBuilder builder) {
  builder
    ..failure = true
    ..message = action.payload;
}

void _succeeded(ResetPassState state, Action<String> action,
    ResetPassStateBuilder builder) {
  builder
    ..failure = false
    ..message = action.payload;
}

void _showRequest(
    ResetPassState state, Action<void> action, ResetPassStateBuilder builder) {
  builder..replace(ResetPassState());
}

void _showReset(ResetPassState state, Action<ShowPassResetPayload> action,
    ResetPassStateBuilder builder) {
  builder.replace(
    ResetPassState(
      (b) => b
        ..email = action.payload.email
        ..token = action.payload.token,
    ),
  );
}
