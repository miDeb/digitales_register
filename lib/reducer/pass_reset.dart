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
  builder.replace(ResetPassState());
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
