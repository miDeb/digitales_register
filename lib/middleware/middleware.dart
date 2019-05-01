import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:redux/redux.dart';

import '../actions.dart';
import '../app_state.dart';
import '../main.dart';
import '../serializers.dart';
import '../wrapper.dart';
import 'absences.dart';
import 'calendar.dart';
import 'days.dart';
import 'grades.dart';
import 'login.dart';
import 'notifications.dart';
import 'pass.dart';
import 'routing.dart';

final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

List<Middleware<AppState>> createMiddleware() {
  final wrapper = Wrapper();
  return <Middleware<AppState>>[
    _createTap(wrapper),
    _saveStateMiddleware,
    TypedMiddleware(_saveNoDataMiddleware),
    TypedMiddleware(_deleteDataMiddleware),
    _createLoad(),
    _createRefresh(),
    _createNoInternet(),
    _createRefreshNoInternet(wrapper),
    TypedMiddleware<AppState, LoggedInAction>(
      (store, action, next) => _loggedIn(store, action, next, _secureStorage),
    ),
    ...daysMiddlewares(wrapper),
    ...routingMiddlewares(wrapper),
    ...loginMiddlewares(wrapper, _secureStorage),
    ...notificationsMiddlewares(wrapper),
    ...gradesMiddlewares(wrapper),
    ...absencesMiddlewares(wrapper),
    ...calendarMiddlewares(wrapper),
    ...passMiddlewares(wrapper, _secureStorage),
  ];
}

TypedMiddleware<AppState, TapAction> _createTap(Wrapper wrapper) =>
    TypedMiddleware(
      (_, __, ___) {
        wrapper.interaction();
        // do not call next: this action is only to update the logout time
      },
    );

TypedMiddleware<AppState, RefreshNoInternetAction> _createRefreshNoInternet(
    Wrapper wrapper) {
  return TypedMiddleware(
      (Store<AppState> store, RefreshNoInternetAction action, next) async {
    next(action);
    if (await wrapper.noInternet) {
      store.dispatch(NoInternetAction(true));
    } else {
      store.dispatch(NoInternetAction(false));
      store.dispatch(LoadAction());
    }
  });
}

TypedMiddleware<AppState, LoadAction> _createLoad() {
  return TypedMiddleware(
    (Store<AppState> store, LoadAction action, NextDispatcher next) async {
      next(action);

      final user = await _secureStorage.read(key: "user");
      final pass = await _secureStorage.read(key: "pass");
      if (user != null && pass != null) {
        store.dispatch(
          LoginAction(user, pass, true),
        );
      } else
        store.dispatch(ShowLoginAction());
    },
  );
}

TypedMiddleware<AppState, RefreshAction> _createRefresh() {
  return TypedMiddleware(
    (Store<AppState> store, RefreshAction action, NextDispatcher next) async {
      next(action);
      store.dispatch(LoadDaysAction(store.state.dayState.future));
      store.dispatch(LoadNotificationsAction());
    },
  );
}

TypedMiddleware<AppState, NoInternetAction> _createNoInternet() {
  return TypedMiddleware(
      (Store<AppState> store, NoInternetAction action, NextDispatcher next) {
    if (action.noInternet) Fluttertoast.showToast(msg: "Kein Internet");
    next(action);
  });
}

var _saveUnderway = false;

GradesState _lastGradesState;
DayState _lastDayState;
CalendarState _lastCalendarState;
AbsenceState _lastAbsenceState;
NotificationState _lastNotificationState;
SettingsState _lastSettingsState;
AppState _lastAppState;

void _loggedIn(Store<AppState> store, LoggedInAction action,
    NextDispatcher next, FlutterSecureStorage secureStorage) async {
  if (!store.state.settingsState.noPasswordSaving && !action.fromStorage) {
    store.dispatch(SavePassAction());
  }

  final vals = await secureStorage.readAll();
  final user = action.userName.hashCode;
  final dayState = _lastDayState = vals["$user::homework"] != null
      ? serializers.deserialize(json.decode(vals["$user::homework"]))
          as DayState
      : store.state.dayState;
  final gradesState = _lastGradesState = vals["$user::grades"] != null
      ? serializers.deserialize(json.decode(vals["$user::grades"]))
          as GradesState
      : store.state.gradesState;
  final notificationState = _lastNotificationState =
      vals["$user::notifications"] != null
          ? serializers.deserialize(json.decode(vals["$user::notifications"]))
              as NotificationState
          : store.state.notificationState;
  final absenceState = _lastAbsenceState = vals["$user::absences"] != null
      ? serializers.deserialize(json.decode(vals["$user::absences"]))
          as AbsenceState
      : store.state.absenceState;
  final calendarState = _lastCalendarState = vals["$user::calendar"] != null
      ? serializers.deserialize(json.decode(vals["$user::calendar"]))
          as CalendarState
      : store.state.calendarState;
  final settingsState = _lastSettingsState = vals["$user::settings"] != null
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

_saveStateMiddleware(Store<AppState> store, action, NextDispatcher next) async {
  next(action);
  if (!_saveUnderway &&
      store.state.loginState.loggedIn &&
      store.state.loginState.userName != null &&
      _lastAppState != store.state) {
    final user = store.state.loginState.userName.hashCode;
    if (!store.state.settingsState.noDataSaving) {
      _saveUnderway = true;
      final delay = Duration(seconds: 5);
      await Future.delayed(delay, () async {
        _saveUnderway = false;
        _lastAppState = store.state;
        final user = store.state.loginState.userName.hashCode;
        if (_lastGradesState != store.state.gradesState)
          _secureStorage.write(
              key: "$user::grades",
              value:
                  json.encode(serializers.serialize(store.state.gradesState)));
        if (_lastDayState != store.state.dayState)
          _secureStorage.write(
              key: "$user::homework",
              value: json.encode(serializers.serialize(store.state.dayState)));
        if (_lastCalendarState != store.state.calendarState)
          _secureStorage.write(
              key: "$user::calendar",
              value: json
                  .encode(serializers.serialize(store.state.calendarState)));
        if (_lastAbsenceState != store.state.absenceState)
          _secureStorage.write(
              key: "$user::absences",
              value:
                  json.encode(serializers.serialize(store.state.absenceState)));
        if (_lastNotificationState != store.state.notificationState)
          _secureStorage.write(
              key: "$user::notifications",
              value: json.encode(
                  serializers.serialize(store.state.notificationState)));
      });
      _lastAbsenceState = store.state.absenceState;
      _lastCalendarState = store.state.calendarState;
      _lastDayState = store.state.dayState;
      _lastGradesState = store.state.gradesState;
      _lastNotificationState = store.state.notificationState;
    }
    if (_lastSettingsState != store.state.settingsState)
      _secureStorage.write(
          key: "$user::settings",
          value: json.encode(serializers.serialize(store.state.settingsState)));
    _lastSettingsState = store.state.settingsState;
  }
}

_saveNoDataMiddleware(Store<AppState> store, SetSaveNoDataAction action, next) {
  next(action);
  if (action.noSave && store.state.settingsState.deleteDataOnLogout) {
    store.dispatch(SetDeleteDataOnLogoutAction(false));
  }
  if (action.noSave) {
    store.dispatch(DeleteDataAction());
  }
}

_deleteDataMiddleware(Store<AppState> store, DeleteDataAction action, next) {
  final user = store.state.loginState.userName.hashCode;
  _secureStorage.delete(key: "$user::grades");
  _secureStorage.delete(key: "$user::notifications");
  _secureStorage.delete(key: "$user::homework");
  _secureStorage.delete(key: "$user::calendar");
  _secureStorage.delete(key: "$user::absences");
  _lastAbsenceState = _lastAppState = _lastCalendarState =
      _lastDayState = _lastGradesState = _lastNotificationState = null;
}
