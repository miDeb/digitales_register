part of 'middleware.dart';

final _passMiddleware =
    MiddlewareBuilder<AppState, AppStateBuilder, AppActions>()
      ..add(SettingsActionsNames.offlineEnabled, _enableOffline)
      ..add(SettingsActionsNames.saveNoPass, _setSavePass)
      ..add(SavePassActionsNames.save, _savePass)
      ..add(SavePassActionsNames.delete, _deletePass);

void _enableOffline(MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next, Action<bool> action) async {
  next(action);
  final user = _secureStorage.read(key: "user");
  final pass = _secureStorage.read(key: "pass");
  final url = _secureStorage.read(key: "url");
  _secureStorage.write(
    key: "login",
    value: json.encode(
      {
        "user": user,
        "pass": pass,
        "url": url,
        "offlineEnabled": action.payload,
      },
    ),
  );
}

void _setSavePass(MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next, Action<bool> action) async {
  next(action);
  _wrapper.safeMode = action.payload;
  if (!api.state.loginState.loggedIn) return;
  if (!action.payload) {
    api.actions.savePassActions.save();
  } else {
    api.actions.savePassActions.delete();
  }
}

void _savePass(MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next, Action<void> action) {
  next(action);
  if (_wrapper.user == null || _wrapper.pass == null) return;
  _secureStorage.write(
    key: "login",
    value: json.encode(
      {
        "user": _wrapper.user,
        "pass": _wrapper.pass,
        "url": _wrapper.url,
        "offlineEnabled": api.state.settingsState.offlineEnabled
      },
    ),
  );
}

void _deletePass(MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next, Action<void> action) {
  next(action);
  _secureStorage.delete(key: "login");
}
