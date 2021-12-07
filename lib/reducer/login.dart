// Copyright (C) 2021 Michael Debertol
//
// This file is part of digitales_register.
//
// digitales_register is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// digitales_register is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with digitales_register.  If not, see <http://www.gnu.org/licenses/>.

import 'package:built_collection/built_collection.dart';
import 'package:built_redux/built_redux.dart';

import '../actions/login_actions.dart';
import '../actions/routing_actions.dart';
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
  ..add(LoginActionsNames.setAvailableAccounts, _setAvailableAccounts)
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
    ..loading = action.payload.keepShowingLoadingIndicator
    ..loggedIn = true;
}

void _loggingIn(
    LoginState state, Action<void> action, LoginStateBuilder builder) {
  builder.loading = true;
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
    ..loading = false
    ..changePassword = true
    ..mustChangePassword = action.payload;
}

void _showLogin(
    LoginState state, Action<void> action, LoginStateBuilder builder) {
  builder.changePassword = false;
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

void _setAvailableAccounts(
    LoginState state, Action<List<String>> action, LoginStateBuilder builder) {
  builder.otherAccounts = ListBuilder(action.payload);
}
