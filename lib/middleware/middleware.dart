import 'dart:convert';
import 'dart:io';

import 'package:built_redux/built_redux.dart';
import 'package:flutter/material.dart' hide Action, Notification;
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:mutex/mutex.dart';
import 'package:requests/requests.dart';

import '../actions/absences_actions.dart';
import '../actions/app_actions.dart';
import '../actions/calendar_actions.dart';
import '../actions/certificate_actions.dart';
import '../actions/dashboard_actions.dart';
import '../actions/grades_actions.dart';
import '../actions/login_actions.dart';
import '../actions/notifications_actions.dart';
import '../actions/profile_actions.dart';
import '../actions/routing_actions.dart';
import '../actions/save_pass_actions.dart';
import '../actions/settings_actions.dart';
import '../app_state.dart';
import '../data.dart';
import '../linux.dart';
import '../main.dart';
import '../serializers.dart';
import '../util.dart';
import '../wrapper.dart';

part 'absences.dart';
part 'calendar.dart';
part 'certificate.dart';
part 'dashboard.dart';
part 'grades.dart';
part 'login.dart';
part 'notifications.dart';
part 'pass.dart';
part 'profile.dart';
part 'routing.dart';

final FlutterSecureStorage _secureStorage = getFlutterSecureStorage();
final _wrapper = Wrapper();

final middleware = [
  _errorMiddleware,
  _saveStateMiddleware,
  (MiddlewareBuilder<AppState, AppStateBuilder, AppActions>()
        ..add(LoginActionsNames.updateLogout, _tap)
        ..add(SettingsActionsNames.saveNoData, _saveNoData)
        ..add(AppActionsNames.deleteData, _deleteData)
        ..add(AppActionsNames.load, _load)
        ..add(AppActionsNames.start, _start)
        ..add(DashboardActionsNames.refresh, _refresh)
        ..add(AppActionsNames.refreshNoInternet, _refreshNoInternet)
        ..add(LoginActionsNames.loggedIn, _loggedIn)
        ..add(AppActionsNames.restarted, _restarted)
        ..combine(_absencesMiddleware)
        ..combine(_calendarMiddleware)
        ..combine(_dashboardMiddleware)
        ..combine(_gradesMiddleware)
        ..combine(_loginMiddleware)
        ..combine(_notificationsMiddleware)
        ..combine(_passMiddleware)
        ..combine(_routingMiddleware)
        ..combine(_certificateMiddleware)
        ..combine(_profileMiddleware))
      .build(),
];

NextActionHandler _errorMiddleware(
        MiddlewareApi<AppState, AppStateBuilder, AppActions> api) =>
    (ActionHandler next) => (Action action) {
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
                                ClipboardData(text: e.stackTrace)),
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

          if (action.name == AppActionsNames.error.name) {
            handleError(action.payload);
          } else {
            try {
              next(action);
            } catch (e) {
              handleError(e);
            }
          }
        };

void _tap(MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next, Action<void> action) {
  _wrapper.interaction();
  // do not call next: this action is only to update the logout time
}

void _refreshNoInternet(
    MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next,
    Action<bool> action) async {
  next(action);
  final noInternet = await _wrapper.noInternet;
  final prevNoInternet = api.state.noInternet;
  api.actions.noInternet(noInternet);
  if (prevNoInternet != noInternet && action.payload != true) {
    api.actions.load();
  }
}

void _load(MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next, Action<void> action) async {
  next(action);
  navigatorKey.currentState.popUntil((route) => route.isFirst);
  final login = json.decode(await _secureStorage.read(key: "login") ?? "{}");
  final user = login["user"];
  final pass = login["pass"];
  final url = login["url"] ??
      "https://vinzentinum.digitalesregister.it"; // be backwards compatible
  final offlineEnabled = login["offlineEnabled"];
  if ((api.state.url != null && api.state.url != url) ||
      (api.state.loginState.userName != null &&
          api.state.loginState.userName != user)) {
    api.actions.savePassActions.delete();
    api.actions.routingActions.showLogin();
  } else {
    api.actions.setUrl(url);
    if (user != null && pass != null) {
      api.actions.loginActions.login(
        LoginPayload(
          (b) => b
            ..user = user
            ..pass = pass
            ..url = url
            ..fromStorage = true
            ..offlineEnabled = offlineEnabled,
        ),
      );
    } else {
      api.actions.routingActions.showLogin();
    }
  }
  api.actions.refreshNoInternet(true);
}

void _refresh(MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next, Action<void> action) {
  next(action);
  api.actions.dashboardActions.load(api.state.dashboardState.future);
  api.actions.notificationsActions.load();
}

var _saveUnderway = false;

SettingsState _lastSettingsState;

void _loggedIn(MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next, Action<LoggedInPayload> action) async {
  if (!api.state.settingsState.noPasswordSaving &&
      !action.payload.fromStorage) {
    api.actions.savePassActions.save();
  }

  if (!api.state.loginState.loggedIn) {
    final user = action.payload.username.hashCode;
    final file = File(
        "${(await getApplicationDocumentsDirectory()).path}/app_state_$user.json");
    if (await file.exists()) {
      try {
        AppState serializedState =
            serializers.deserialize(json.decode(await file.readAsString()));
        final currentState = api.state;
        api.actions.mountAppState(
          serializedState.rebuild(
            (b) => b
              ..loginState.replace(currentState.loginState)
              ..noInternet = currentState.noInternet
              ..config = currentState.config?.toBuilder()
              ..dashboardState.future = true
              ..gradesState.semester.replace(
                    currentState.gradesState.semester == Semester.all
                        ? serializedState.gradesState.semester
                        : currentState.gradesState.semester,
                  ),
          ),
        );

        // next not at the beginning: bug fix (serialization)
        next(action);

        api.actions.settingsActions
            .saveNoPass(serializedState.settingsState.noPasswordSaving);
      } catch (e) {
        showToast(
            msg: "Fehler beim Laden der gespeicherten Daten",
            toastLength: Toast.LENGTH_LONG);
        print(e);
        next(action);
      }
    } else {
      next(action);
    }

    navigatorKey.currentState.popUntil((route) => route.isFirst);
  } else {
    next(action);
  }
  api.state.loginState.callAfterLogin.forEach((f) => f());
  api.actions.dashboardActions.load(api.state.dashboardState.future);
  api.actions.notificationsActions.load();
}

var _lastSave = "";
AppState _stateToSave;

NextActionHandler _saveStateMiddleware(
        MiddlewareApi<AppState, AppStateBuilder, AppActions> api) =>
    (ActionHandler next) => (Action action) {
          next(action);
          if (api.state.loginState.loggedIn &&
              api.state.loginState.userName != null) {
            _stateToSave = api.state;
            if (_saveUnderway) {
              return;
            }
            final user = _stateToSave.loginState.userName.hashCode;
            final delay = action.name == AppActionsNames.saveState.name
                ? Duration.zero
                : Duration(seconds: 5);
            _saveUnderway = true;
            Future.delayed(
              delay,
              () {
                _saveUnderway = false;
                if (!_stateToSave.settingsState.noDataSaving) {
                  final save = json.encode(serializers.serialize(_stateToSave));
                  if (_lastSave == save) return;
                  _lastSave = save;
                  _writeToStorage(
                    user.toString(),
                    save,
                  );
                } else {
                  if (_lastSettingsState != _stateToSave.settingsState)
                    _writeToStorage(
                      user.toString(),
                      json.encode(
                        {
                          "settings":
                              serializers.serialize(_stateToSave.settingsState),
                        },
                      ),
                    );
                  _lastSettingsState = _stateToSave.settingsState;
                }
              },
            );
          }
        };

Future<File> _storageFile(String key) async {
  return File(
      "${(await getApplicationDocumentsDirectory()).path}/app_state_$key.json");
}

void _writeToStorage(String key, String txt) async {
  final file = await _storageFile(key);
  if (!await file.exists()) {
    await file.create();
  }
  (await _storageFile(key)).writeAsString(txt);
}

void _saveNoData(
  MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
  ActionHandler next,
  Action<void> action,
) {
  next(action);
  api.actions.saveState();
}

void _deleteData(
  MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
  ActionHandler next,
  Action<void> action,
) async {
  next(action);
  final file = await _storageFile(
    api.state.loginState.userName.hashCode.toString(),
  );
  if (await file.exists()) {
    file.delete();
  }
}

void _restarted(
  MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
  ActionHandler next,
  Action<void> action,
) {
  next(action);
  if (DateTime.now().difference(_wrapper.lastInteraction).inMinutes > 3) {
    navigatorKey.currentState.popUntil((route) => route.isFirst);
    api.actions.loginActions.clearAfterLoginCallbacks();
    api.actions.load();
  }
}

void _start(
  MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
  ActionHandler next,
  Action<Uri> action,
) {
  api.actions.loginActions.clearAfterLoginCallbacks();
  if (action.payload != null) {
    api.actions.setUrl(action.payload.origin);
    final parameters = action.payload.queryParameters;
    switch (parameters["semesterWechsel"]) {
      case "1":
        api.actions.loginActions.addAfterLoginCallback(
          () => api.actions.gradesActions.setSemester(Semester.first),
        );
        break;
      case "2":
        api.actions.loginActions.addAfterLoginCallback(
          () => api.actions.gradesActions.setSemester(Semester.second),
        );
    }
    switch (action.payload.path) {
      case "":
      case "/v2/":
        break;
      case "/v2/login":
        if (parameters["resetmail"] == "true") {
          final email = parameters["email"];
          final token = parameters["token"];
          api.actions.routingActions.showPassReset(
            ShowPassResetPayload(
              (b) => b
                ..token = token
                ..email = email,
            ),
          );
          return;
        }
        if (parameters["username"] != null) {
          api.actions.loginActions.setUsername(parameters["username"]);
        }
        if (parameters["redirect"] != null) {
          redirectAfterLogin(parameters["redirect"].replaceFirst("#", ""), api);
        }
        break;
      default:
        showToast(msg: "Dieser Link konnte nicht geöffnet werden");
    }
    redirectAfterLogin(action.payload.fragment, api);
  }
  api.actions.load();
}

void redirectAfterLogin(
    String location, MiddlewareApi<AppState, AppStateBuilder, AppActions> api) {
  switch (location) {
    case "":
    case "dashboard/student":
      break;
    case "student/absences":
      api.actions.loginActions.addAfterLoginCallback(
        api.actions.routingActions.showAbsences,
      );
      break;
    case "calendar/student":
      api.actions.loginActions.addAfterLoginCallback(
        api.actions.routingActions.showCalendar,
      );
      break;
    case "student/subjects":
      api.actions.loginActions.addAfterLoginCallback(
        api.actions.routingActions.showGrades,
      );
      break;
    case "student/certificate":
      api.actions.loginActions.addAfterLoginCallback(
        api.actions.routingActions.showCertificate,
      );
      break;
    default:
      showToast(msg: "Dieser Link konnte nicht geöffnet werden");
  }
}
