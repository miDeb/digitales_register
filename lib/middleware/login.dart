import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:redux/redux.dart';

import '../actions/app_actions.dart';
import '../actions/login_actions.dart';
import '../actions/routing_actions.dart';
import '../actions/save_pass_actions.dart';
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
  store.dispatch(MountAppStateAction());
  store.dispatch(ShowLoginAction());
}

void _login(LoginAction action, NextDispatcher next, Store<AppState> store,
    Wrapper wrapper) async {
  action = action.rebuild(
    (b) => b
      ..user = action.user.trim()
      ..url = action.url.trim(),
  );
  next(action);
  if (action.user == "" || action.pass == "") {
    store.dispatch(
      LoginFailedAction(
        (b) async => b
          ..cause = "Bitte gib etwas ein"
          ..offlineEnabled = action.offlineEnabled
          ..noInternet = await wrapper.noInternet
          ..username = action.user,
      ),
    );
    return;
  }
  store.dispatch(LoggingInAction());
  await wrapper.login(
    action.user,
    action.pass,
    action.url,
    logout: () => store.dispatch(
      LogoutAction(
        (b) => b
          ..hard = store.state.settingsState.noPasswordSaving
          ..forced = true,
      ),
    ),
    configLoaded: () => store.dispatch(
      SetConfigAction(
        (b) => b..config = wrapper.config.toBuilder(),
      ),
    ),
    relogin: () => store.dispatch(LoggedInAgainAutomatically()),
    addProtocolItem: (item) => store.dispatch(
      AddNetworkProtocolItemAction(
        (b) => b..item = item.toBuilder(),
      ),
    ),
  );
  if (wrapper.loggedIn)
    store.dispatch(
      LoggedInAction(
        (b) => b
          ..username = wrapper.user
          ..fromStorage = action.fromStorage,
      ),
    );
  else
    store.dispatch(
      LoginFailedAction(
        (b) async => b
          ..cause = wrapper.error
          ..offlineEnabled = action.offlineEnabled
          ..noInternet = await wrapper.noInternet
          ..username = action.user,
      ),
    );
}

void _loginFailed(
    NextDispatcher next, LoginFailedAction action, Store<AppState> store) {
  next(action);
  if (action.noInternet) {
    if (action.offlineEnabled) {
      store.dispatch(
        LoggedInAction(
          (b) => b
            ..username = action.username
            ..fromStorage = true,
        ),
      );
    }
    store.dispatch(NoInternetAction((b) => b..noInternet = true));
    return;
  }
  if (!store.state.currentRouteIsLogin) {
    // loginScreen not already shown
    store.dispatch(ShowLoginAction());
  }
}
