import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:redux/redux.dart';

import '../actions.dart';
import '../app_state.dart';
import '../wrapper.dart';

List<Middleware<AppState>> passMiddlewares(
        Wrapper wrapper, FlutterSecureStorage storage) =>
    [
      TypedMiddleware((Store<AppState> store, SetSaveNoPassAction action,
              NextDispatcher next) =>
          _saveNoPass(next, action, wrapper, store)),
      TypedMiddleware(
          (Store<AppState> store, SavePassAction action, NextDispatcher next) =>
              _savePass(next, action, wrapper, storage)),
      TypedMiddleware((Store<AppState> store, DeletePassAction action,
              NextDispatcher next) =>
          _deletePass(next, action, storage))
    ];

void _saveNoPass(NextDispatcher next, SetSaveNoPassAction action,
    Wrapper wrapper, Store<AppState> store) {
  next(action);
  wrapper.safeMode = action.noSave;
  if (action.noSave && !store.state.settingsState.noDataSaving) {
    store.dispatch(SetSaveNoDataAction(true));
  }
  if (!store.state.loginState.loggedIn) return;
  if (!action.noSave) {
    store.dispatch(SavePassAction());
  } else
    store.dispatch(DeletePassAction());
}

void _savePass(NextDispatcher next, SavePassAction action, Wrapper wrapper,
    FlutterSecureStorage storage) {
  next(action);
  storage.write(key: "user", value: wrapper.user);
  storage.write(key: "pass", value: wrapper.pass);
}

void _deletePass(NextDispatcher next, DeletePassAction action,
    FlutterSecureStorage storage) {
  next(action);
  storage.deleteAll();
}
