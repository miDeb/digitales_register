import 'dart:convert';
import 'dart:io';

import 'package:built_collection/built_collection.dart';
import 'package:dr/middleware/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:redux/redux.dart';

import '../actions.dart';
import '../app_state.dart';
import '../linux.dart';
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

final FlutterSecureStorage _secureStorage = getFlutterSecureStorage();

List<Middleware<AppState>> createMiddleware() {
  final wrapper = Wrapper();
  return <Middleware<AppState>>[
    (store, action, next) {
      print(action);
      next(action);
    },
    errorMiddleware,
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
    ...settingsMiddleware
  ];
}

void errorMiddleware(Store<AppState> store, action, NextDispatcher next) {
  void handleError(e) {
    print(e);
    navigatorKey.currentState.push(
      MaterialPageRoute(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.red,
              title: Text("Fehler!"),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  RaisedButton(
                    child: Text("In die Zwischenablage kopieren"),
                    onPressed: () => Clipboard.setData(
                        new ClipboardData(text: e.stackTrace)),
                  ),
                  Text(
                      "Ein unvorhergesehener Fehler ist aufgetreten:\n\n$e\n${e.stackTrace}"),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  if (action is ErrorAction) {
    handleError(action.e);
  }
  try {
    next(action);
  } catch (e) {
    handleError(e);
  }
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

      final login =
          json.decode(await _secureStorage.read(key: "login") ?? "{}");
      final user = login["user"];
      final pass = login["pass"];
      final url = login["url"] ??
          "https://vinzentinum.digitalesregister.it"; // be backwards compatible
      final offlineEnabled = login["offlineEnabled"];
      if (user != null && pass != null) {
        store.dispatch(
          LoginAction(user, pass, url, true, offlineEnabled),
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
    if (action.noInternet) showToast(msg: "Kein Internet");
    next(action);
  });
}

var _saveUnderway = false;

SettingsState _lastSettingsState;

void _loggedIn(Store<AppState> store, LoggedInAction action,
    NextDispatcher next, FlutterSecureStorage secureStorage) async {
  if (!store.state.settingsState.noPasswordSaving && !action.fromStorage) {
    store.dispatch(SavePassAction());
  }

  if (!store.state.loginState.loggedIn) {
    final user = action.userName.hashCode;
    final file =
        File("${(await getApplicationDocumentsDirectory()).path}/$user.data");
    final vals = json.decode(
      await file.exists() && await file.length() > 0
          ? await file.readAsString()
          : await secureStorage.read(key: user.toString()) ?? "{}",
    );
    final dayState = vals["homework"] != null
        ? serializers.deserialize(vals["homework"]) as DayState
        : store.state.dayState;
    final gradesState = vals["grades"] != null
        ? serializers.deserialize(vals["grades"]) as GradesState
        : store.state.gradesState;
    final notificationState = vals["notifications"] != null
        ? serializers.deserialize(vals["notifications"]) as NotificationState
        : store.state.notificationState;
    final absenceState = vals["absences"] != null
        ? serializers.deserialize(vals["absences"]) as AbsenceState
        : store.state.absenceState;
    final calendarState = vals["calendar"] != null
        ? serializers.deserialize(vals["calendar"]) as CalendarState
        : store.state.calendarState;
    final settingsState = _lastSettingsState = vals["settings"] != null
        ? serializers.deserialize(vals["settings"]) as SettingsState
        : store.state.settingsState;
    store.dispatch(
      MountAppStateAction(
        store.state.rebuild(
          (b) => b
            ..dayState = (dayState.toBuilder()
              ..future = true
              ..blacklist ??= ListBuilder([]))
            ..gradesState = (gradesState.toBuilder()
              ..semester = store.state.gradesState.semester.toBuilder())
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
  } else {
    next(action);
  }
  store.dispatch(LoadDaysAction(true));
  store.dispatch(LoadNotificationsAction());
}

var _lastSave = "";

_saveStateMiddleware(Store<AppState> store, action, NextDispatcher next) {
  next(action);
  if (!_saveUnderway &&
      store.state.loginState.loggedIn &&
      store.state.loginState.userName != null) {
    final user = store.state.loginState.userName.hashCode;
    if (!store.state.settingsState.noDataSaving) {
      _saveUnderway = true;
      final delay =
          action is SaveStateAction ? Duration.zero : Duration(seconds: 5);

      Future.delayed(delay, () async {
        _saveUnderway = false;
        final save = json.encode({
          "grades": serializers.serialize(store.state.gradesState),
          "homework": serializers.serialize(store.state.dayState),
          "calendar": serializers.serialize(store.state.calendarState),
          "absences": store.state.absenceState != null
              ? serializers.serialize(store.state.absenceState)
              : null,
          "notifications": serializers.serialize(store.state.notificationState),
          "settings": serializers.serialize(store.state.settingsState),
        });
        if (_lastSave == save) return;
        writeToStorage(
          user.toString(),
          save,
        );
      });
    } else {
      if (_lastSettingsState != store.state.settingsState)
        writeToStorage(
          user.toString(),
          json.encode(
            {
              "settings": serializers.serialize(store.state.settingsState),
            },
          ),
        );
      _lastSettingsState = store.state.settingsState;
    }
  }
}

void writeToStorage(String key, String txt) async {
  File("${(await getApplicationDocumentsDirectory()).path}/$key.data")
      .writeAsString(txt, flush: true);
}

_saveNoDataMiddleware(Store<AppState> store, SetSaveNoDataAction action, next) {
  next(action);
  if (action.noSave && store.state.settingsState.deleteDataOnLogout) {
    store.dispatch(SetDeleteDataOnLogoutAction(false));
  }
  if (action.noSave) {
    store.dispatch(DeleteDataAction());
  } else {
    store.dispatch(SaveStateAction());
  }
}

_deleteDataMiddleware(
    Store<AppState> store, DeleteDataAction action, next) async {
  final user = store.state.loginState.userName.hashCode;
  await _secureStorage.delete(key: "$user");
  _lastSave = "";
  await _secureStorage.write(
    key: "$user",
    value: json.encode(
      {
        "settings": serializers.serialize(store.state.settingsState),
      },
    ),
  );
}
