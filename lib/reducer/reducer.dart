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
import 'package:dr/actions/login_actions.dart';
import 'package:dr/util.dart';

import '../actions/app_actions.dart';
import '../app_state.dart';
import 'absences.dart';
import 'calendar.dart';
import 'certificate.dart';
import 'dashboard.dart';
import 'grades.dart';
import 'login.dart';
import 'messages.dart';
import 'network_protocol.dart';
import 'notifications.dart';
import 'profile_reducer.dart';
import 'settings.dart';

final appReducerBuilder = ReducerBuilder<AppState, AppStateBuilder>()
  ..add(AppActionsNames.mountAppState, _mountState)
  ..add(AppActionsNames.noInternet, _noInternet)
  ..add(LoginActionsNames.loggingIn, _loggingIn)
  ..add(AppActionsNames.setConfig, _config)
  ..add(AppActionsNames.setUrl, _setUrl)
  ..combineNested(absencesReducerBuilder)
  ..combineNested(calendarReducerBuilder)
  ..combineNested(dashboardReducerBuilder)
  ..combineNested(gradesReducerBuilder)
  ..combineNested(loginReducerBuilder)
  ..combineNested(networkProtocolReducerBuilder)
  ..combineNested(notificationsReducerBuilder)
  ..combineNested(settingsReducerBuilder)
  ..combineNested(certificateReducerBuilder)
  ..combineNested(profileReducerBuilder)
  ..combineNested(messagesReducerBuilder);

void _noInternet(AppState state, Action<bool> action, AppStateBuilder builder) {
  builder.noInternet = action.payload;
}

void _loggingIn(AppState state, Action<void> action, AppStateBuilder builder) {
  builder.noInternet = false;
}

void _config(AppState state, Action<Config> action, AppStateBuilder builder) {
  builder.config.replace(action.payload);
}

void _mountState(
    AppState state, Action<AppState> action, AppStateBuilder builder) {
  builder.replace(action.payload);
}

void _setUrl(AppState state, Action<String> action, AppStateBuilder builder) {
  builder.url = fixupUrl(action.payload);
}
