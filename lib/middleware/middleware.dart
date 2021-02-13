import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:built_redux/built_redux.dart';
import 'package:dio/dio.dart' as dio;
import 'package:dr/actions/messages_actions.dart';
import 'package:dr/container/absences_page_container.dart';
import 'package:dr/container/calendar_container.dart';
import 'package:dr/container/certificate_container.dart';
import 'package:dr/container/grades_page_container.dart';
import 'package:dr/container/messages_container.dart';
import 'package:dr/container/settings_page.dart';
import 'package:flutter/material.dart' hide Action, Notification;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:mutex/mutex.dart';
import 'package:open_file/open_file.dart';
import 'package:package_info/package_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

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
part 'messages.dart';
part 'notifications.dart';
part 'pass.dart';
part 'profile.dart';
part 'routing.dart';
part 'settings.dart';

late FlutterSecureStorage secureStorage;

var _wrapper = Wrapper();

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
        ..combine(_messagesMiddleware)
        ..combine(_profileMiddleware)
        ..combine(_settingsMiddleware))
      .build(),
];

NextActionHandler _errorMiddleware(
        MiddlewareApi<AppState, AppStateBuilder, AppActions> api) =>
    (ActionHandler next) => (Action action) async {
          Future<void> handleError(e, StackTrace? trace) async {
            log("Error caught by error middleware",
                error: e, stackTrace: trace);
            var stackTrace = trace;
            try {
              stackTrace ??= e.stackTrace as StackTrace?;
            } catch (e) {
              // we can't get a stack trace
            }
            PackageInfo? info;
            try {
              info = await PackageInfo.fromPlatform();
            } catch (e) {
              log("failed to get app version for feedback (error)");
            }
            final appVersion = info?.version;
            var error = e.toString();
            if (e is! ParseException) {
              // ParseExceptions will already provide a more precise stack trace
              error += "\n\n$stackTrace";
            }
            error +=
                "\n\nApp Version: $appVersion\nOS: ${Platform.operatingSystem}";
            navigatorKey?.currentState?.push(
              MaterialPageRoute(
                fullscreenDialog: true,
                builder: (_) {
                  return Scaffold(
                    appBar: AppBar(
                      backgroundColor: Colors.red,
                      title: const Text("Fehler!"),
                    ),
                    body: ListView(
                      padding: const EdgeInsets.all(16),
                      children: <Widget>[
                        Center(
                          child: ElevatedButton(
                            onPressed: () async {
                              launch(
                                  "https://docs.google.com/forms/d/e/1FAIpQLSdvfb5ZuV4EWTlkiS_BV7bPJL8HrGkFsFSZQ9K_12rFJUsQJQ/viewform?usp=pp_url&entry.1875208362=${Uri.encodeQueryComponent(error)}");
                            },
                            child: const Text("Entwickler benachrichtigen"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            """
Ein Fehler ist aufgetreten.
${e is UnexpectedLogoutException ? """

Dieser Fehler kann auftreten, wenn zwei Geräte gleichzeitig auf dasselbe Konto zugreifen.
In diesem Fall kannst du versuchen, die App zu schließen und erneut zu öffnen.

Falls dies nicht zutrifft, bitte benachrichtige uns, damit wir diesen Fehler beheben können.""" : e is ParseException ? """

Beim Einlesen der Daten ist ein Fehler aufgetreten.
Bitte benachrichtige uns, damit wir diesen Fehler beheben können.
Bitte beachte, dass das Fehlerprotokoll möglicherweise private Daten enthält.""" : """

Eine Funktion wird eventuell noch nicht unterstützt.
Bitte benachrichtige uns, damit wir diesen Fehler beheben können:"""}

 --  Fehlerprotokoll: --

$error""",
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          }

          if (action.name == AppActionsNames.error.name) {
            handleError(action.payload, null);
          } else {
            try {
              await next(action);
            } catch (e, stackTrace) {
              handleError(e, stackTrace);
            }
          }
        };

void _tap(MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next, Action<void> action) {
  _wrapper.interaction();
  // do not call next: this action is only to update the logout time
}

Future<void> _refreshNoInternet(
    MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next,
    Action<void> action) async {
  await next(action);
  final noInternet = await _wrapper.noInternet;
  final prevNoInternet = api.state.noInternet;
  if (prevNoInternet != noInternet) {
    if (noInternet) {
      showSnackBar("Keine Verbindung");
      _wrapper.logout(
        hard: false,
        logoutForcedByServer: true,
      );
    }
    api.actions.noInternet(noInternet);
    api.actions.load();
  }
}

Future<void> _load(MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next, Action<void> action) async {
  await next(action);
  if (!api.state.noInternet) _popAll();
  final login = json.decode(await secureStorage.read(key: "login") ?? "{}");
  final user = getString(login["user"]);
  final pass = getString(login["pass"]);
  final url = getString(login["url"]);
  final offlineEnabled = getBool(login["offlineEnabled"]);
  final List<String> otherAccounts = List.from(
    (login["otherAccounts"] as List?)?.map((login) => login["user"]) ?? [],
  );
  api.actions.loginActions.setAvailableAccounts(otherAccounts);
  if ((api.state.url != null && api.state.url != url) ||
      (api.state.loginState.username != null &&
          api.state.loginState.username != user)) {
    // TODO: Figure out when exactly we'd hit this code path and how to handle it better.
    api.actions.savePassActions.delete();
    api.actions.routingActions.showLogin();
  } else {
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
}

Future<void> _refresh(MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next, Action<void> action) async {
  await next(action);
  api.actions.dashboardActions.load(api.state.dashboardState.future);
  api.actions.notificationsActions.load();
}

Future<void> _loggedIn(MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next, Action<LoggedInPayload> action) async {
  if (!api.state.settingsState.noPasswordSaving &&
      !action.payload.fromStorage) {
    api.actions.savePassActions.save();
  }
  _deletedData = false;
  final key = getStorageKey(action.payload.username, _wrapper.loginAddress);
  if (!api.state.loginState.loggedIn) {
    final state = await _readFromStorage(key);
    if (state != null) {
      try {
        final serializedState =
            serializers.deserialize(json.decode(state) as Object);
        if (serializedState is SettingsState) {
          api.actions.mountAppState(
            api.state.rebuild(
              (b) => b
                ..settingsState.replace(
                  serializedState,
                ),
            ),
          );
        } else if (serializedState is AppState) {
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
        }

        // next not at the beginning: bug fix (serialization)
        await next(action);

        api.actions.settingsActions
            .saveNoPass(api.state.settingsState.noPasswordSaving);
      } catch (e) {
        showSnackBar("Fehler beim Laden der gespeicherten Daten");
        log("Failed to load data", error: e);
        await next(action);
      }
    } else {
      // navigatorKey is null in unit tests
      if (navigatorKey?.currentContext != null) {
        final saveData = await _showDataSavingDialog() ?? false;
        api.actions.settingsActions.saveNoData(!saveData);
      }
      await next(action);
    }

    _popAll();
  } else {
    await next(action);
  }
  for (final callback in api.state.loginState.callAfterLogin) {
    callback();
  }
  api.actions.dashboardActions.load(api.state.dashboardState.future);
  api.actions.notificationsActions.load();
}

var _saveUnderway = false;

var _lastSave = "";
String? _lastUsernameSaved;
late AppState _stateToSave;
// This is to avoid saving data in an action right after deleting data,
// which would restore it.
bool _deletedData = false;

NextActionHandler _saveStateMiddleware(
        MiddlewareApi<AppState, AppStateBuilder, AppActions> api) =>
    (ActionHandler next) => (Action action) async {
          await next(action);
          if (api.state.loginState.loggedIn &&
              api.state.loginState.username != null) {
            _stateToSave = api.state;
            final bool immediately =
                action.name == AppActionsNames.saveState.name;
            if (_saveUnderway && !immediately) {
              return;
            }
            final user = getStorageKey(
                _stateToSave.loginState.username, _wrapper.loginAddress);
            _saveUnderway = true;

            void save() {
              _saveUnderway = false;
              String toSave;
              if (!_stateToSave.settingsState.noDataSaving && !_deletedData) {
                toSave = json.encode(
                  serializers.serialize(_stateToSave),
                );
              } else {
                toSave = json.encode(
                  serializers.serialize(_stateToSave.settingsState),
                );
              }
              if (_lastSave == toSave && _lastUsernameSaved == user) return;
              _lastSave = toSave;
              _lastUsernameSaved = user;
              _writeToStorage(
                user,
                toSave,
              );
            }

            if (immediately) {
              save();
            } else {
              Future.delayed(const Duration(seconds: 5), save);
            }
          }
        };

String getStorageKey(String? user, String server) {
  return json.encode({"username": user, "server_url": server});
}

Future<void> _writeToStorage(String key, String txt) async {
  await secureStorage.write(key: key, value: txt);
}

Future<String?> _readFromStorage(String key) async {
  return secureStorage.read(key: key);
}

Future<void> _saveNoData(
  MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
  ActionHandler next,
  Action<void> action,
) async {
  await next(action);
  api.actions.saveState();
}

Future<void> _deleteData(
  MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
  ActionHandler next,
  Action<void> action,
) async {
  await next(action);
  _deletedData = true;
  await api.actions.saveState();
}

Future<void> _restarted(
  MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
  ActionHandler next,
  Action<void> action,
) async {
  await next(action);
  if (DateTime.now().difference(_wrapper.lastInteraction).inMinutes > 3) {
    _popAll();
    api.actions.loginActions.clearAfterLoginCallbacks();
    api.actions.load();
  }
}

void _start(
  MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
  ActionHandler next,
  Action<Uri?> action,
) {
  api.actions.loginActions.clearAfterLoginCallbacks();
  if (action.payload != null) {
    api.actions.setUrl(action.payload!.origin);
    final parameters = action.payload!.queryParameters;
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
    switch (action.payload!.path) {
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
          api.actions.loginActions.setUsername(parameters["username"]!);
        }
        if (parameters["redirect"] != null) {
          redirectAfterLogin(
              parameters["redirect"]!.replaceFirst("#", ""), api);
        }
        break;
      default:
        showSnackBar("Dieser Link konnte nicht geöffnet werden");
    }
    redirectAfterLogin(action.payload!.fragment, api);
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
    case "message/list":
      api.actions.loginActions.addAfterLoginCallback(
        api.actions.routingActions.showMessages,
      );
      break;
    default:
      showSnackBar("Dieser Link konnte nicht geöffnet werden");
  }
}

void _popAll() {
  if (WidgetsBinding.instance != null) {
    navigatorKey?.currentState?.popUntil((route) => route.isFirst);
    nestedNavKey.currentState?.popUntil((route) => route.isFirst);
  }
}

Future<bool?> _showDataSavingDialog() {
  return showDialog(
    barrierDismissible: false,
    context: navigatorKey!.currentContext!,
    builder: (context) => AlertDialog(
      title: const Text("Möchtest du alle Funktionen dieser App nutzen?"),
      content: const Text("""
Um alle Funktionen zu benutzen, müssen deine Daten (Hausaufgaben, Noten usw.) auf diesem Gerät gespeichert werden.

So ist es z.B. möglich, einen Offline-Modus bereitzustellen und neue, geänderte oder gelöschte Einträge hervorzuheben.

Du kannst dies in den Einstellungen jederzeit wieder ändern."""),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text("Daten nicht speichern"),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text("Daten speichern"),
        )
      ],
    ),
  );
}
