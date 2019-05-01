import 'package:dr/main.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:redux/redux.dart';

import '../actions.dart';
import '../app_state.dart';
import '../wrapper.dart';

List<Middleware<AppState>> loginMiddlewares(
        Wrapper wrapper, FlutterSecureStorage secureStorage) =>
    [
      TypedMiddleware<AppState, LogoutAction>(
        (store, action, next) => _logout(next, action, store, wrapper),
      ),
      TypedMiddleware<AppState, LoginAction>(
        (store, action, next) => _login(action, next, store, wrapper),
      ),
      TypedMiddleware<AppState, LoginFailedAction>(
        (store, action, next) => _loginFailed(next, action, store),
      ),
    ];

void _logout(NextDispatcher next, LogoutAction action, Store<AppState> store,
    Wrapper wrapper) {
  next(action);
  if (!store.state.settingsState.noPasswordSaving && action.hard) {
    store.dispatch(DeletePassAction());
  }
  if (store.state.settingsState.deleteDataOnLogout && action.hard) {
    store.dispatch(DeleteDataAction());
  }
  if (!action.forced) {
    wrapper.logout(hard: action.hard);
  }
  store.dispatch(MountAppStateAction(initialState));
  store.dispatch(ShowLoginAction());
}

void _login(LoginAction action, NextDispatcher next, Store<AppState> store,
    Wrapper wrapper) async {
  action = LoginAction(action.user.trim(), action.pass, action.fromStorage);
  next(action);
  if (action.user == "" || action.pass == "") {
    store.dispatch(LoginFailedAction("Bitte gib etwas ein", action.fromStorage,
        await wrapper.noInternet, action.user));
    return;
  }
  store.dispatch(LoggingInAction());
  await wrapper.login(
    action.user,
    action.pass,
    logout: () => store.dispatch(
        LogoutAction(store.state.settingsState.noPasswordSaving, true)),
    configLoaded: () => store.dispatch(
          SetConfigAction(wrapper.config),
        ),
    relogin: () => store.dispatch(LoggedInAgainAutomatically()),
  );
  if (wrapper.loggedIn)
    store.dispatch(LoggedInAction(wrapper.user, action.fromStorage));
  else
    store.dispatch(LoginFailedAction(wrapper.error, action.fromStorage,
        await wrapper.noInternet, action.user));
}

void _loginFailed(
    NextDispatcher next, LoginFailedAction action, Store<AppState> store) {
  next(action);
  if (action.noInternet) {
    if (action.fromStorage) {
      store.dispatch(LoggedInAction(action.username, action.fromStorage));
    }
    store.dispatch(NoInternetAction(true));
    return;
  }
  if (!store.state.currentRouteIsLogin) {
    // loginScreen not already shown
    store.dispatch(ShowLoginAction());
  }
}
