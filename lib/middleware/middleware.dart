import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../actions.dart';
import '../app_state.dart';
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
        _saveStateMiddleware,
        _createTap(wrapper),
        _createLoad(),
        _createSetSettings(),
        _createRefresh(),
        _createNoInternet(),
      ] +
      daysMiddlewares(wrapper) +
      routingMiddlewares(wrapper) +
      loginMiddlewares(wrapper, _secureStorage) +
      notificationsMiddlewares(wrapper) +
      gradesMiddlewares(wrapper) +
      absencesMiddlewares(wrapper) +
      calendarMiddlewares(wrapper) +
      passMiddlewares(wrapper, _secureStorage);
}

TypedMiddleware<AppState, TapAction> _createTap(Wrapper wrapper) =>
    TypedMiddleware(
      (_, __, ___) {
        wrapper.interaction();
        // do not call next: this action is only to update the logout time
      },
    );

SettingsState fetchSettings(SharedPreferences prefs) {
  return SettingsState((b) => b
    ..askWhenDelete = prefs.getBool("askWhenDeleteReminder") ?? true
    ..noPasswordSaving = prefs.getBool("safeMode") ?? false
    ..noDataSaving = prefs.getBool("saveNoData") ?? false
    ..typeSorted = prefs.getBool("gradesTypeSorted") ?? true
    ..showCancelled = prefs.getBool("showCancelledGrades") ?? false
    ..doubleTapForDone = prefs.getBool("doubleTapHDone") ?? false
    ..noAverageForAllSemester = prefs.getBool("noAvgForAll") ?? false);
}

TypedMiddleware<AppState, SettingsAction> _createSetSettings() {
  return TypedMiddleware((Store<AppState> store, SettingsAction action,
      NextDispatcher next) async {
    next(action);
    final preferences = await SharedPreferences.getInstance();
    preferences.setBool(
      "saveNoData",
      store.state.settingsState.noDataSaving,
    );
    preferences.setBool(
      "safeMode",
      store.state.settingsState.noPasswordSaving,
    );
    preferences.setBool(
      "doubleTapHDone",
      store.state.settingsState.doubleTapForDone,
    );
    preferences.setBool(
      "noAvgForAll",
      store.state.settingsState.noAverageForAllSemester,
    );
    preferences.setBool(
      "askWhenDeleteReminder",
      store.state.settingsState.askWhenDelete,
    );
    preferences.setBool(
      "gradesTypeSorted",
      store.state.settingsState.typeSorted,
    );
    preferences.setBool(
      "showCancelledGrades",
      store.state.settingsState.showCancelled,
    );
  });
}

TypedMiddleware<AppState, LoadAction> _createLoad() {
  return TypedMiddleware(
    (Store<AppState> store, LoadAction action, NextDispatcher next) async {
      next(action);
      var saveNoPass = store.state.settingsState?.noPasswordSaving;
      final preferences = await SharedPreferences.getInstance();
      if (saveNoPass == null) {
        saveNoPass = preferences.getBool("safeMode") == true;
      }
      store.dispatch(SetSaveNoPassAction(saveNoPass));
      store.dispatch(SettingsLoadedAction(fetchSettings(preferences)));

      if (saveNoPass) {
        store.dispatch(ShowLoginAction());
      } else {
        final user = await _secureStorage.read(key: "user");
        final pass = await _secureStorage.read(key: "pass");
        if (user != null && pass != null) {
          store.dispatch(
            LoginAction(user, pass, true),
          );
        } else
          store.dispatch(ShowLoginAction());
      }
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

var _call = 0;
var _lastSaving = DateTime(0);

_saveStateMiddleware(Store<AppState> store, action, NextDispatcher next) async {
  final stateBefore = store.state;
  next(action);
  if (store.state.loginState.loggedIn &&
      store.state.loginState.userName != null &&
      stateBefore != store.state) {
    if (!store.state.settingsState.noDataSaving) {
      final call = ++_call;
      final delay = _lastSaving.difference(DateTime.now()).inSeconds < 5
          ? Duration()
          : Duration(seconds: 5);
      await Future.delayed(delay, () async {
        if (call < _call) {
          return;
        }
        _lastSaving = DateTime.now();
        final user = store.state.loginState.userName.hashCode;
        Future.wait([
          _secureStorage.write(
              key: "$user::grades",
              value:
                  json.encode(serializers.serialize(store.state.gradesState))),
          _secureStorage.write(
              key: "$user::homework",
              value: json.encode(serializers.serialize(store.state.dayState))),
          _secureStorage.write(
              key: "$user::calendar",
              value: json
                  .encode(serializers.serialize(store.state.calendarState))),
          (store.state.absenceState != null)
              ? _secureStorage.write(
                  key: "$user::absences",
                  value: json
                      .encode(serializers.serialize(store.state.absenceState)))
              : Future.value(null),
          _secureStorage.write(
              key: "$user::notifications",
              value: json.encode(
                  serializers.serialize(store.state.notificationState))),
        ]);
      });
    } else if (store.state.settingsState.noDataSaving) {
      _secureStorage.deleteAll();
    }
  }
}
