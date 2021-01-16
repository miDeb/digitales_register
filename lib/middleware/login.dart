part of 'middleware.dart';

final _loginMiddleware =
    MiddlewareBuilder<AppState, AppStateBuilder, AppActions>()
      ..add(LoginActionsNames.logout, _logout)
      ..add(LoginActionsNames.login, _login)
      ..add(LoginActionsNames.loginFailed, _loginFailed)
      ..add(LoginActionsNames.showChangePass, _showChangePass)
      ..add(LoginActionsNames.changePass, _changePass)
      ..add(LoginActionsNames.requestPassReset, _requestPassReset)
      ..add(LoginActionsNames.resetPass, _resetPass);

void _logout(MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next, Action<LogoutPayload> action) {
  if (!api.state.settingsState.noPasswordSaving && action.payload.hard) {
    api.actions.savePassActions.delete();
  }
  if (api.state.settingsState.deleteDataOnLogout && action.payload.hard) {
    api.actions.deleteData();
  }
  if (!action.payload.forced) {
    // sidenote: action.payload.hard is _always_ true here
    _wrapper.logout(hard: action.payload.hard);
  }
  next(action);
  if (action.payload.hard) {
    _wrapper = Wrapper();
    api.actions.mountAppState(AppState());
    api.actions.load();
  }
}

void _login(MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next, Action<LoginPayload> action) async {
  next(action);
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
  api.actions.loginActions.loggingIn();
  final result = await _wrapper.login(
    action.payload.user,
    action.payload.pass,
    action.payload.url,
    logout: () => api.actions.loginActions.logout(
      LogoutPayload(
        (b) => b
          ..hard = api.state.settingsState.noPasswordSaving
          ..forced = true,
      ),
    ),
    configLoaded: () => api.actions.setConfig(_wrapper.config),
    relogin: api.actions.loginActions.automaticallyReloggedIn,
    addProtocolItem: api.actions.addNetworkProtocolItem,
  );
  if (_wrapper.loggedIn) {
    api.actions.loginActions.loggedIn(
      LoggedInPayload(
        (b) => b
          ..username = _wrapper.user
          ..fromStorage = action.payload.fromStorage,
      ),
    );
  } else if (result is Map && result["error"] == "password_expired") {
    api.actions.savePassActions.delete();
    api.actions.loginActions.showChangePass(true);
  } else {
    final noInternet = await _wrapper.noInternet;
    if (noInternet) {
      api.actions.noInternet(true);
      if (action.payload.offlineEnabled) {
        api.actions.loginActions.loggedIn(
          LoggedInPayload(
            (b) => b
              ..username = action.payload.user
              ..fromStorage = true,
          ),
        );
        return;
      }
    }
    api.actions.loginActions.loginFailed(
      LoginFailedPayload((b) => b
        ..cause = _wrapper.error
        ..username = action.payload.user),
    );
  }
}

void _changePass(MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next, Action<ChangePassPayload> action) async {
  next(action);
  final result = await _wrapper.changePass(
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
        ..cause = _wrapper.error
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
    navigatorKey.currentState.pop();
    showSnackBar("Passwort erfolgreich geändert");
  }
}

void _loginFailed(MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next, Action<LoginFailedPayload> action) {
  next(action);

  api.actions.savePassActions.delete();
  api.actions.routingActions.showLogin();
}

void _showChangePass(MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next, Action<void> action) {
  api.actions.routingActions.showLogin();
  next(action);
}

void _requestPassReset(MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next, Action<RequestPassResetPayload> action) async {
  final result = (await dio.Dio().post(
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
    api.actions.loginActions.passResetSucceeded(result["message"]);
  }
}

void _resetPass(MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next, Action<String> action) async {
  final result = (await dio.Dio().post(
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
    api.actions.loginActions.passResetSucceeded(result["message"]);
  }
}
