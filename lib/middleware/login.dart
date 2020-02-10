part of 'middleware.dart';

final _loginMiddleware = MiddlewareBuilder<AppState, AppStateBuilder, AppActions>()
  ..add(LoginActionsNames.logout, _logout)
  ..add(LoginActionsNames.login, _login)
  ..add(LoginActionsNames.loginFailed, _loginFailed)
  ..add(LoginActionsNames.showChangePass, _showChangePass)
  ..add(LoginActionsNames.changePass, _changePass);

void _logout(MiddlewareApi<AppState, AppStateBuilder, AppActions> api, ActionHandler next,
    Action<LogoutPayload> action) {
  next(action);
  if (!api.state.settingsState.noPasswordSaving && action.payload.hard) {
    api.actions.savePassActions.delete();
  }
  if (api.state.settingsState.deleteDataOnLogout && action.payload.hard) {
    api.actions.deleteData();
  }
  if (!action.payload.forced) {
    _wrapper.logout(hard: action.payload.hard);
  }
  if (action.payload.hard) {
    api.actions.mountAppState(AppState());
    api.actions.load();
  }
}

void _login(MiddlewareApi<AppState, AppStateBuilder, AppActions> api, ActionHandler next,
    Action<LoginPayload> action) async {
  next(action);
  if (action.payload.user == "" || action.payload.pass == "") {
    api.actions.loginActions.loginFailed(
      LoginFailedPayload(
        (b) async => b
          ..cause = "Bitte gib etwas ein"
          ..offlineEnabled = action.payload.offlineEnabled
          ..noInternet = false
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
    api.actions.loginActions.showChangePass(true);
  } else {
    final noInternet = await _wrapper.noInternet;
    api.actions.loginActions.loginFailed(
      LoginFailedPayload(
        (b) => b
          ..cause = _wrapper.error
          ..offlineEnabled = action.payload.offlineEnabled
          ..noInternet = noInternet
          ..username = action.payload.user
          ..fromStorage = action.payload.fromStorage,
      ),
    );
  }
}

void _changePass(MiddlewareApi<AppState, AppStateBuilder, AppActions> api, ActionHandler next,
    Action<ChangePassPayload> action) async {
  next(action);
  final result = await _wrapper.changePass(
    action.payload.url,
    action.payload.user,
    action.payload.oldPass,
    action.payload.newPass,
  );
  if (result["error"] != null) {
    api.actions.loginActions.loginFailed(
      LoginFailedPayload(
        (b) => b
          ..cause = result["error"].toString()
          ..username = action.payload.user
          ..fromStorage = false
          ..noInternet = false
          ..offlineEnabled = false,
      ),
    );
  } else {
    api.actions.loginActions.login(LoginPayload((b) => b
      ..user = action.payload.user
      ..pass = action.payload.newPass
      ..fromStorage = false));
    navigatorKey.currentState.pop();
    api.actions.isLoginRoute(false);
    showToast(msg: "Passwort erfolgreich geändert");
  }
}

void _loginFailed(MiddlewareApi<AppState, AppStateBuilder, AppActions> api, ActionHandler next,
    Action<LoginFailedPayload> action) {
  next(action);
  if (action.payload.noInternet) {
    if (action.payload.offlineEnabled) {
      api.actions.loginActions.loggedIn(
        LoggedInPayload(
          (b) => b
            ..username = action.payload.username
            ..fromStorage = true,
        ),
      );
      return;
    }
    api.actions.noInternet(true);
  }
  api.actions.routingActions.showLogin();
}

void _showChangePass(MiddlewareApi<AppState, AppStateBuilder, AppActions> api, ActionHandler next,
    Action<void> action) {
  next(action);
  api.actions.routingActions.showLogin();
}
