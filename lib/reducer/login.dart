import 'package:built_redux/built_redux.dart';

import '../actions/login_actions.dart';
import '../app_state.dart';

final loginReducerBuilder =
    NestedReducerBuilder<AppState, AppStateBuilder, LoginState, LoginStateBuilder>(
  (s) => s.loginState,
  (b) => b.loginState,
)
      ..add(LoginActionsNames.loginFailed, _loginFailed)
      ..add(LoginActionsNames.loggedIn, _loggedIn)
      ..add(LoginActionsNames.loggingIn, _loggingIn)
      ..add(LoginActionsNames.logout, _logout);

void _loginFailed(LoginState state, Action<LoginFailedPayload> action, LoginStateBuilder builder) {
  builder
    ..errorMsg = action.payload.cause
    ..userName = action.payload.username
    ..loading = false
    ..loggedIn = false;
}

void _loggedIn(LoginState state, Action<LoggedInPayload> action, LoginStateBuilder builder) {
  builder
    ..errorMsg = null
    ..userName = action.payload.username
    ..loading = false
    ..loggedIn = true;
}

void _loggingIn(LoginState state, Action<void> action, LoginStateBuilder builder) {
  builder..loading = true;
}

void _logout(LoginState state, Action<LogoutPayload> action, LoginStateBuilder builder) {
  builder
    ..loggedIn = false
    ..userName = null;
}
