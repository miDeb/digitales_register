import 'package:built_redux/built_redux.dart';
import 'package:dr/actions/app_actions.dart';

import '../actions/login_actions.dart';
import '../app_state.dart';

final loginReducerBuilder = NestedReducerBuilder<AppState, AppStateBuilder,
    LoginState, LoginStateBuilder>(
  (s) => s.loginState,
  (b) => b.loginState,
)
  ..add(LoginActionsNames.loginFailed, _loginFailed)
  ..add(LoginActionsNames.loggedIn, _loggedIn)
  ..add(LoginActionsNames.loggingIn, _loggingIn)
  ..add(LoginActionsNames.logout, _logout)
  ..add(LoginActionsNames.showChangePass, _changePass)
  ..add(AppActionsNames.isLoginRoute, _isLoginRoute);

void _loginFailed(LoginState state, Action<LoginFailedPayload> action,
    LoginStateBuilder builder) {
  builder
    ..errorMsg = action.payload.cause
    ..userName = action.payload.username
    ..loading = false
    ..loggedIn = false;
}

void _loggedIn(LoginState state, Action<LoggedInPayload> action,
    LoginStateBuilder builder) {
  builder
    ..errorMsg = null
    ..userName = action.payload.username
    ..loading = false
    ..loggedIn = true;
}

void _loggingIn(
    LoginState state, Action<void> action, LoginStateBuilder builder) {
  builder..loading = true;
}

void _logout(
    LoginState state, Action<LogoutPayload> action, LoginStateBuilder builder) {
  builder
    ..loggedIn = false
    ..userName = null;
}

void _changePass(
    LoginState state, Action<bool> action, LoginStateBuilder builder) {
  builder
    ..changePassword = true
    ..mustChangePassword = action.payload;
}

void _isLoginRoute(
    LoginState state, Action<bool> action, LoginStateBuilder builder) {
  if (!action.payload) {
    builder.changePassword = false;
  }
}
