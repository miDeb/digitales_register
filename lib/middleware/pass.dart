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

final _passMiddleware =
    MiddlewareBuilder<AppState, AppStateBuilder, AppActions>()
      ..add(SettingsActionsNames.saveNoPass, _setSavePass)
      ..add(SavePassActionsNames.save, _savePass)
      ..add(SavePassActionsNames.delete, _deletePass);

Future<void> _setSavePass(
    MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next,
    Action<bool> action) async {
  await next(action);
  wrapper.safeMode = action.payload;
  if (!api.state.loginState.loggedIn) return;
  if (!action.payload) {
    api.actions.savePassActions.save();
  } else {
    api.actions.savePassActions.delete();
  }
}

Future<void> _savePass(MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next, Action<void> action) async {
  await next(action);
  if (wrapper.user == null || wrapper.pass == null || wrapper.safeMode) {
    return;
  }
  secureStorage.write(
    key: "login",
    value: json.encode(
      <String, Object?>{
        "user": wrapper.user,
        "pass": wrapper.pass,
        "url": wrapper.url,
        "otherAccounts": json.decode(
            await secureStorage.read(key: "login") ?? "{}")["otherAccounts"],
      },
    ),
  );
}

Future<void> _deletePass(
    MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next,
    Action<void> action) async {
  await next(action);
  secureStorage.write(
    key: "login",
    value: json.encode(
      <String, Object?>{
        "url": wrapper.url,
        "otherAccounts": json.decode(
            await secureStorage.read(key: "login") ?? "{}")["otherAccounts"],
      },
    ),
  );
}
