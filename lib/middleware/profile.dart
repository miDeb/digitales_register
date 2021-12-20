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

part of 'middleware.dart';

final _profileMiddleware = MiddlewareBuilder<AppState, AppStateBuilder,
    AppActions>()
  ..add(ProfileActionsNames.load, _loadProfile)
  ..add(ProfileActionsNames.sendNotificationEmails, _setSendNotificationEmails)
  ..add(ProfileActionsNames.changeEmail, _changeEmail);

Future<void> _loadProfile(
    MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next,
    Action<void> action) async {
  await next(action);
  if (api.state.noInternet) return;
  final dynamic result = await wrapper.send("api/profile/get");
  if (result == null) {
    return;
  }
  await api.actions.profileActions.loaded(result as Object);
}

Future<void> _setSendNotificationEmails(
    MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next,
    Action<bool> action) async {
  await next(action);
  final dynamic result = await wrapper.send(
    "api/profile/updateNotificationSettings",
    args: {
      "notificationsEnabled": action.payload,
    },
  );
  if (result == null) {
    return;
  }
}

Future<void> _changeEmail(
    MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next,
    Action<ChangeEmailPayload> action) async {
  await next(action);
  final dynamic result = await wrapper.send(
    "api/profile/updateProfile",
    args: {
      "email": action.payload.email,
      "password": action.payload.pass,
    },
  );
  if (result == null) {
    return;
  }
  if (result["error"] == null) {
    showSnackBar(result["message"] as String);
    navigatorKey?.currentState?.pop();
  } else {
    showSnackBar("[${result["error"]}]: ${result["message"]}");
  }
  await api.actions.profileActions.load();
}
