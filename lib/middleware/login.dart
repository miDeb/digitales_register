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

final _loginMiddleware =
    MiddlewareBuilder<AppState, AppStateBuilder, AppActions>()
      ..add(LoginActionsNames.logout, _logout)
      ..add(LoginActionsNames.login, _login)
      ..add(LoginActionsNames.loginFailed, _loginFailed)
      ..add(LoginActionsNames.showChangePass, _showChangePass)
      ..add(LoginActionsNames.changePass, _changePass)
      ..add(LoginActionsNames.requestPassReset, _requestPassReset)
      ..add(LoginActionsNames.resetPass, _resetPass)
      ..add(LoginActionsNames.addAccount, _addAccount)
      ..add(LoginActionsNames.selectAccount, _selectAccount);

Future<void> _logout(MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next, Action<LogoutPayload> action) async {
  if (!api.state.settingsState.noPasswordSaving && action.payload.hard) {
    await secureStorage.write(
      key: "login",
      value: json.encode(
        <String, Object?>{
          "url": wrapper.url,
          if (await secureStorage.containsKey(key: "login"))
            "otherAccounts": json.decode(
                (await secureStorage.read(key: "login"))!)["otherAccounts"],
        },
      ),
    );
  }
  if (api.state.settingsState.deleteDataOnLogout && action.payload.hard) {
    await api.actions.deleteData();
  }
  if (!action.payload.forced) {
    assert(action.payload.hard);
    wrapper.logout(hard: action.payload.hard);
  }
  await next(action);
  if (action.payload.hard) {
    wrapper = Wrapper();
    api.actions.mountAppState(AppState());
    api.actions.load();
  }
}

Future<void> _login(MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next, Action<LoginPayload> action) async {
  await next(action);
  if (action.payload.user == "" || action.payload.pass == "") {
    api.actions.loginActions.loginFailed(
      LoginFailedPayload(
        (b) async => b
          ..cause = "Bitte gib etwas ein"
          ..username = action.payload.user,
      ),
    );
    return;
  }

  final url = fixupUrl(action.payload.url);
  api.actions.loginActions.loggingIn();
  final dynamic result = await wrapper.login(
    action.payload.user,
    action.payload.pass,
    null,
    url,
    logout: () => api.actions.loginActions.logout(
      LogoutPayload(
        (b) => b
          ..hard = api.state.settingsState.noPasswordSaving
          ..forced = true,
      ),
    ),
    configLoaded: () => api.actions.setConfig(wrapper.config),
    relogin: api.actions.loginActions.automaticallyReloggedIn,
    addProtocolItem: api.actions.addNetworkProtocolItem,
  );
  if (wrapper.loggedIn) {
    if (!wrapper.config.isStudentOrParent) {
      wrapper.logout(hard: true);
      api.actions.loginActions.loginFailed(
        LoginFailedPayload(
          (b) => b..cause = "Dieser Benutzertyp wird nicht unterstützt.",
        ),
      );
      _showUserTypeNotSupported(url);
      return;
    }
    await api.actions.loginActions.loggedIn(
      LoggedInPayload(
        (b) => b
          ..username = wrapper.user
          ..fromStorage = action.payload.fromStorage,
      ),
    );
  } else if (result is Map && result["error"] == "password_expired") {
    api.actions.savePassActions.delete();
    api.actions.loginActions.showChangePass(true);
  } else {
    final noInternet = await wrapper.noInternet;
    if (noInternet) {
      api.actions.noInternet(true);
      if (action.payload.offlineEnabled) {
        await api.actions.loginActions.loggedIn(
          LoggedInPayload(
            (b) => b
              ..username = action.payload.user
              ..fromStorage = true,
          ),
        );
        api.actions.setUrl(url);
        return;
      }
    }
    api.actions.loginActions.loginFailed(
      LoginFailedPayload((b) => b
        ..cause = wrapper.error
        ..username = action.payload.user),
    );
  }
  api.actions.setUrl(url);
}

Future<void> _changePass(
    MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next,
    Action<ChangePassPayload> action) async {
  await next(action);
  final dynamic result = await wrapper.changePass(
    action.payload.url,
    action.payload.user,
    action.payload.oldPass,
    action.payload.newPass,
  );
  api.actions.savePassActions.save();
  if (result == null) {
    api.actions.refreshNoInternet();
    return;
  }
  if (result["error"] != null) {
    api.actions.loginActions.loginFailed(
      LoginFailedPayload((b) => b
        ..cause = wrapper.error
        ..username = action.payload.user),
    );
  } else {
    api.actions.loginActions.login(
      LoginPayload(
        (b) => b
          ..user = action.payload.user
          ..pass = action.payload.newPass
          ..fromStorage = false
          ..url = action.payload.url,
      ),
    );
    navigatorKey?.currentState?.pop();
    showSnackBar("Passwort erfolgreich geändert");
  }
}

Future<void> _loginFailed(
    MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next,
    Action<LoginFailedPayload> action) async {
  await next(action);

  api.actions.savePassActions.delete();
  api.actions.routingActions.showLogin();
}

Future<void> _showChangePass(
    MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next,
    Action<void> action) async {
  api.actions.routingActions.showLogin();
  await next(action);
}

@visibleForTesting
dio.Dio? passDio;

Future<void> _requestPassReset(
    MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next,
    Action<RequestPassResetPayload> action) async {
  // the api url DOES NOT contain /v2/ in the path. This is intentional.
  final dynamic result = (await (passDio ?? dio.Dio()).post<dynamic>(
    "${api.state.url}/api/auth/resetPassword",
    data: {
      "email": action.payload.email,
      "username": action.payload.user,
    },
  ))
      .data;
  if (result["error"] != null) {
    api.actions.loginActions
        .passResetFailed("[${result["error"]}]: ${result["message"]}");
  } else {
    api.actions.loginActions
        .passResetSucceeded((result["message"] as String?)!);
  }
}

Future<void> _resetPass(
    MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next,
    Action<String> action) async {
  // the api url DOES NOT contain /v2/ in the path. This is intentional.
  final dynamic result = (await (passDio ?? dio.Dio()).post<dynamic>(
    "${api.state.url}/api/auth/setNewPassword",
    data: {
      "username": "",
      "token": api.state.loginState.resetPassState.token,
      "email": api.state.loginState.resetPassState.email,
      "oldPassword": "",
      "newPassword": action.payload,
    },
  ))
      .data;
  if (result["error"] != null) {
    api.actions.loginActions
        .passResetFailed("[${result["error"]}]: ${result["message"]}");
  } else {
    api.actions.loginActions.passResetSucceeded(result["message"] as String);
  }
}

Future<void> _addAccount(
    MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next,
    Action<void> action) async {
  await next(action);
  // Move the current default user credentials into `otherAccounts`
  final dynamic login = json.decode((await secureStorage.read(key: "login"))!);
  final otherAccounts = login["otherAccounts"] as List? ?? <Object?>[];
  if (login["user"] != null &&
      login["pass"] != null &&
      login["url"] != null &&
      login["offlineEnabled"] != null) {
    otherAccounts.insert(0, <String, Object?>{
      "user": login["user"],
      "pass": login["pass"],
      "url": login["url"],
      "offlineEnabled": login["offlineEnabled"],
    });
  }
  await secureStorage.write(
    key: "login",
    value: json.encode(
      <String, Object?>{
        "url": login["url"],
        "otherAccounts": otherAccounts,
      },
    ),
  );
  api.actions.mountAppState(AppState());
  api.actions.load();
}

Future<void> _selectAccount(
    MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next,
    Action<int> action) async {
  await next(action);
  final dynamic login = json.decode((await secureStorage.read(key: "login"))!);
  login["otherAccounts"] ??= <Object?>[];
  final otherAccounts = login["otherAccounts"] as List<Object?>;
  var selectedIndex = action.payload;
  if (login["user"] != null &&
      login["pass"] != null &&
      login["url"] != null &&
      login["offlineEnabled"] != null) {
    otherAccounts.insert(0, <String, Object?>{
      "user": login["user"],
      "pass": login["pass"],
      "url": login["url"],
      "offlineEnabled": login["offlineEnabled"],
    });
    selectedIndex += 1;
  }
  final dynamic selected = otherAccounts.removeAt(selectedIndex);
  login["user"] = selected["user"];
  login["pass"] = selected["pass"];
  login["url"] = selected["url"];
  login["offlineEnabled"] = selected["offlineEnabled"];
  await secureStorage.write(key: "login", value: json.encode(login));
  api.actions.mountAppState(AppState());
  api.actions.load();
}

void _showUserTypeNotSupported(String url) {
  navigatorKey?.currentState?.push(
    MaterialPageRoute<void>(
      builder: (context) => Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  "Tut uns leid!",
                  style: Theme.of(context).textTheme.headline4,
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  "Diese App ist ausschließlich für Schüler und Eltern geeignet.",
                  style: Theme.of(context).textTheme.headline5,
                  textAlign: TextAlign.center,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "Zurück",
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () => launch(url),
                    child: const Text(
                      "Hier geht's zur Website",
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
