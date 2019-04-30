import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:redux/redux.dart';

import '../actions.dart';
import '../app_state.dart';
import '../main.dart';
import '../serializers.dart';
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
      TypedMiddleware<AppState, LoggedInAction>(
        (store, action, next) => _loggedIn(store, action, next, secureStorage),
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

void _loggedIn(Store<AppState> store, LoggedInAction action,
    NextDispatcher next, FlutterSecureStorage secureStorage) async {
  if (!store.state.settingsState.noPasswordSaving && !action.fromStorage) {
    store.dispatch(SavePassAction());
  }

  final vals = await secureStorage.readAll();
  final user = action.userName.hashCode;
  final dayState = vals["$user::homework"] != null
      ? serializers.deserialize(json.decode(vals["$user::homework"]))
          as DayState
      : store.state.dayState;
  final gradesState = vals["$user::grades"] != null
      ? serializers.deserialize(json.decode(vals["$user::grades"]))
          as GradesState
      : store.state.gradesState;
  final notificationState = vals["$user::notifications"] != null
      ? serializers.deserialize(json.decode(vals["$user::notifications"]))
          as NotificationState
      : store.state.notificationState;
  final absenceState = vals["$user::absences"] != null
      ? serializers.deserialize(json.decode(vals["$user::absences"]))
          as AbsenceState
      : store.state.absenceState;
  final calendarState = vals["$user::calendar"] != null
      ? serializers.deserialize(json.decode(vals["$user::calendar"]))
          as CalendarState
      : store.state.calendarState;
  final settingsState = vals["$user::settings"] != null
      ? serializers.deserialize(json.decode(vals["$user::settings"]))
          as SettingsState
      : store.state.settingsState;
  store.dispatch(
    MountAppStateAction(
      store.state.rebuild(
        (b) => b
          ..dayState = dayState.toBuilder()
          ..gradesState = gradesState.toBuilder()
          ..notificationState = notificationState.toBuilder()
          ..absenceState = absenceState?.toBuilder()
          ..calendarState = calendarState.toBuilder()
          ..settingsState = settingsState.toBuilder(),
      ),
    ),
  );

  // next not at the beginning: bug fix (serialization)
  next(action);

  store.dispatch(SetSaveNoPassAction(settingsState.noPasswordSaving));

  if (store.state.currentRouteIsLogin) {
    navigatorKey.currentState.pop();
    store.dispatch(SetIsLoginRouteAction(false));
  }
  store.dispatch(LoadDaysAction(true));
  store.dispatch(LoadNotificationsAction());
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
