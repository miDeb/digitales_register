import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:redux/redux.dart';

import '../actions/save_pass_actions.dart';
import '../actions/settings_actions.dart';
import '../app_state.dart';
import '../wrapper.dart';

List<Middleware<AppState>> passMiddlewares(
        Wrapper wrapper, FlutterSecureStorage storage) =>
    [
      TypedMiddleware((Store<AppState> store, SetSaveNoPassAction action,
              NextDispatcher next) =>
          _saveNoPass(next, action, wrapper, store)),
      TypedMiddleware((Store<AppState> store, SetOfflineEnabledAction action,
              NextDispatcher next) =>
          _enableOffline(next, action, wrapper, storage, store)),
      TypedMiddleware(
          (Store<AppState> store, SavePassAction action, NextDispatcher next) =>
              _savePass(next, action, wrapper, storage, store)),
      TypedMiddleware((Store<AppState> store, DeletePassAction action,
              NextDispatcher next) =>
          _deletePass(next, action, storage))
    ];

void _enableOffline(NextDispatcher next, SetOfflineEnabledAction action,
    Wrapper wrapper, FlutterSecureStorage storage, Store<AppState> store) {
  next(action);
  storage.write(
    key: "login",
    value: json.encode(
      {
        "user": wrapper.user,
        "pass": wrapper.pass,
        "offlineEnabled": action.enabled,
      },
    ),
  );
}

void _saveNoPass(NextDispatcher next, SetSaveNoPassAction action,
    Wrapper wrapper, Store<AppState> store) {
  next(action);
  wrapper.safeMode = action.noSave;
  if (action.noSave && store.state.settingsState.deleteDataOnLogout) {
    store.dispatch(SetDeleteDataOnLogoutAction((b) => b..delete = false));
  }
  if (!store.state.loginState.loggedIn) return;
  if (!action.noSave) {
    store.dispatch(SavePassAction());
  } else
    store.dispatch(DeletePassAction());
}

void _savePass(NextDispatcher next, SavePassAction action, Wrapper wrapper,
    FlutterSecureStorage storage, Store<AppState> store) {
  next(action);
  if (wrapper.user == null || wrapper.pass == null) return;
  storage.write(
    key: "login",
    value: json.encode(
      {
        "user": wrapper.user,
        "pass": wrapper.pass,
        "url": wrapper.url,
        "offlineEnabled": store.state.settingsState.offlineEnabled
      },
    ),
  );
}

void _deletePass(NextDispatcher next, DeletePassAction action,
    FlutterSecureStorage storage) {
  next(action);
  storage.delete(key: "login");
}
