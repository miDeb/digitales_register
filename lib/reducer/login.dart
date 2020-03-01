import 'package:built_redux/built_redux.dart';
import 'package:dr/actions/routing_actions.dart';

import '../actions/login_actions.dart';
import '../app_state.dart';
import 'pass_reset.dart';

final loginReducerBuilder = NestedReducerBuilder<AppState, AppStateBuilder,
    LoginState, LoginStateBuilder>(
  (s) => s.loginState,
  (b) => b.loginState,
)
  ..add(LoginActionsNames.setUsername, _setUsername)
  ..add(LoginActionsNames.loginFailed, _loginFailed)
  ..add(LoginActionsNames.loggedIn, _loggedIn)
  ..add(LoginActionsNames.loggingIn, _loggingIn)
  ..add(LoginActionsNames.logout, _logout)
  ..add(LoginActionsNames.showChangePass, _changePass)
  ..add(LoginActionsNames.addAfterLoginCallback, _addAfterLoginCallback)
  ..add(LoginActionsNames.clearAfterLoginCallbacks, _clearAfterLoginCallbacks)
  ..add(RoutingActionsNames.showLogin, _showLogin)
  ..combineReducerBuilder(
    ReducerBuilder()..combineNested(resetPassReducerBuilder),
  );

void _loginFailed(LoginState state, Action<LoginFailedPayload> action,
    LoginStateBuilder builder) {
  builder
    ..errorMsg = action.payload.cause
    ..username = action.payload.username
    ..loading = false
    ..loggedIn = false;
}

void _loggedIn(LoginState state, Action<LoggedInPayload> action,
    LoginStateBuilder builder) {
  builder
    ..errorMsg = null
    ..username = action.payload.username
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
    ..username = null;
}

void _changePass(
    LoginState state, Action<bool> action, LoginStateBuilder builder) {
  builder
    ..changePassword = true
    ..mustChangePassword = action.payload;
}

void _showLogin(
    LoginState state, Action<void> action, LoginStateBuilder builder) {
  builder..changePassword = false;
}

void _addAfterLoginCallback(LoginState state, Action<void Function()> action,
    LoginStateBuilder builder) {
  builder.callAfterLogin.add(action.payload);
}

void _clearAfterLoginCallbacks(
    LoginState state, Action<void> action, LoginStateBuilder builder) {
  builder.callAfterLogin.clear();
}

void _setUsername(
    LoginState state, Action<String> action, LoginStateBuilder builder) {
  builder.username = action.payload;
}
