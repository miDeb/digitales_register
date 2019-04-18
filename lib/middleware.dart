import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart' hide Notification;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:redux/redux.dart';
import 'package:requests/requests.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'actions.dart';
import 'app_state.dart';
import 'data.dart';
import 'main.dart';
import 'serializers.dart';
import 'util.dart';
import 'wrapper.dart';

final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

List<Middleware<AppState>> createMiddleware() {
  final wrapper = Wrapper();
  return [
    _saveStateMiddleware,
    _createTap(wrapper),
    _createLoad(),
    _createSetSettings(),
    _createRefresh(),
    _createLogout(wrapper),
    _createLogin(wrapper),
    _createLoggedIn(),
    _createLoadDays(wrapper),
    _createLoginFailed(),
    _createShowLogin(wrapper),
    _createShowCalendar(),
    _createShowSettings(),
    _createShowAbsencesPageAction(),
    _createSetSaveNoPass(wrapper),
    _createSwitchFuture(),
    _createLoadNotifications(wrapper),
    _createNoInternet(),
    _createSavePass(wrapper),
    _createDeletePass(),
    _createShowNotifications(),
    _createDeleteNotification(wrapper),
    _createDeleteAllNotifications(wrapper),
    _createLoadDetail(wrapper),
    _createLoadSubjects(wrapper),
    _createShowGradesPageAction(),
    _createShowGradesChartPageAction(),
    _createSetGradesSemesterMiddleware(),
    _createDaysNotLoaded(),
    TypedMiddleware<AppState, AddReminderAction>((store, action, next) =>
        _addReminderMiddleware(store, action, next, wrapper)),
    TypedMiddleware<AppState, DeleteHomeworkAction>(
        (store, action, next) => _deleteHomework(store, action, next, wrapper)),
    TypedMiddleware<AppState, ToggleDoneAction>(
        (store, action, next) => _toggleDone(store, action, next, wrapper)),
    TypedMiddleware<AppState, LoadAbsencesAction>(
        (store, action, next) => _loadAbsences(store, action, next, wrapper)),
    _calendarMiddleware,
    _createLoadCalendar(wrapper),
  ];
}

TypedMiddleware<AppState, TapAction> _createTap(Wrapper wrapper) {
  return TypedMiddleware((Store<AppState> store, _, NextDispatcher next) {
    wrapper.interaction();
    // do not call next: this action is only to update the logout time
  });
}

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

TypedMiddleware<AppState, LoadDaysAction> _createLoadDays(Wrapper wrapper) {
  const String homeworks = "api/student/dashboard/dashboard";

  return TypedMiddleware(
    (Store<AppState> store, LoadDaysAction action, NextDispatcher next) async {
      next(action);
      final data = await wrapper.post(homeworks, {"viewFuture": action.future});
      if (data == null) {
        store.dispatch(
          await wrapper.noInternet
              ? DaysNotLoadedAction.noInternet()
              : DaysNotLoadedAction(wrapper.error),
        );
      } else {
        store.dispatch(DaysLoadedAction(List<Map<String, dynamic>>.from(data)
            .map((d) => Day.parse(d))
            .toList()));
      }
    },
  );
}

TypedMiddleware<AppState, DaysNotLoadedAction> _createDaysNotLoaded() {
  return TypedMiddleware(
      (Store<AppState> store, DaysNotLoadedAction action, next) {
    next(action);
    if (action.noInternet) store.dispatch(NoInternetAction(true));
  });
}

TypedMiddleware<AppState, LoadNotificationsAction> _createLoadNotifications(
    Wrapper wrapper) {
  const String notifications = "api/notification/unread";

  return TypedMiddleware(
    (Store<AppState> store, LoadNotificationsAction action,
        NextDispatcher next) async {
      next(action);
      final data = await wrapper.post(notifications);

      if (data != null) {
        store.dispatch(NotificationsLoadedAction(
            List<Map<String, dynamic>>.from(data)
                .map((n) => Notification.parse(n))
                .toList()));
      }
    },
  );
}

TypedMiddleware<AppState, LoadCalendarAction> _createLoadCalendar(
    Wrapper wrapper) {
  const String calendar = "api/calendar/student";

  return TypedMiddleware(
    (Store<AppState> store, LoadCalendarAction action,
        NextDispatcher next) async {
      next(action);
      final data = await wrapper.post(calendar,
          {"startDate": DateFormat("yyyy-MM-dd").format(action.startDate)});

      if (data != null) {
        store.dispatch(CalendarLoadedAction(data));
      }
    },
  );
}

final _calendarMiddleware = TypedMiddleware(
  (Store<AppState> store, action, NextDispatcher next) {
    if (action is LoadNextWeekCalendarAction) {
      store.dispatch(
        LoadCalendarAction(
          store.state.calendarState.currentMonday.add(
            Duration(days: 7),
          ),
        ),
      );
    } else if (action is LoadPrevWeekCalendarAction) {
      store.dispatch(
        LoadCalendarAction(
          store.state.calendarState.currentMonday.subtract(
            Duration(days: 7),
          ),
        ),
      );
    } else if (action is LoadWeekOfDayCalendarAction) {
      store.dispatch(
        LoadCalendarAction(toMonday(action.weekDay)),
      );
    }
    next(action);
  },
);

final colors = List.of(Colors.primaries)
  ..remove(Colors.pink)
  ..remove(Colors.lightBlue)
  ..remove(Colors.lightGreen);

const defaultThick = 2;

TypedMiddleware<AppState, LoadSubjectsAction> _createLoadSubjects(
    Wrapper wrapper) {
  const String subjects = "api/student/all_subjects";

  return TypedMiddleware(
    (Store<AppState> store, LoadSubjectsAction action,
        NextDispatcher next) async {
      next(action);

      if (await wrapper.noInternet) {
        store.dispatch(NoInternetAction(true));
        return;
      }
      final which = store.state.gradesState.semester;

      List<AllSemesterSubject> loadedSubjects =
          List.of(store.state.gradesState.subjects);
      List<int> neededSemester = which.n != null ? [which.n] : [1, 2];
      int lastRequested;

      if (neededSemester
          .remove(lastRequested = store.state.gradesState.serverSemester)) {
        var data = await wrapper.post(subjects, {
          "studentId": store.state.config.userId,
        });
        for (var s in data["subjects"]) {
          final subject = SingleSemesterSubject.parse(s);
          final same = loadedSubjects.firstWhere((i) => i.id == subject.id,
              orElse: () => null);
          if (same != null) {
            loadedSubjects[loadedSubjects.indexOf(same)] =
                same.rebuild((b) => b..subjects[lastRequested] = subject);
          } else
            loadedSubjects.add(
              AllSemesterSubject(
                (b) => b
                  ..subjects = MapBuilder(
                    {lastRequested: subject},
                  ),
              ),
            );
        }
      }
      while (neededSemester.isNotEmpty) {
        await Requests.get(
            "https://vinzentinum.digitalesregister.it/v2/?semesterWechsel=${lastRequested = neededSemester.removeLast()}");
        var data = await wrapper.post(subjects, {
          "studentId": store.state.config.userId,
        });
        for (var s in data["subjects"]) {
          final subject = SingleSemesterSubject.parse(s);
          final same = loadedSubjects.firstWhere((i) => i.id == subject.id,
              orElse: () => null);
          if (same != null) {
            loadedSubjects[loadedSubjects.indexOf(same)] =
                same.rebuild((b) => b..subjects[lastRequested] = subject);
          } else
            loadedSubjects.add(
              AllSemesterSubject(
                (b) => b
                  ..subjects = MapBuilder(
                    {lastRequested: subject},
                  ),
              ),
            );
        }
      }
      if (loadedSubjects.isNotEmpty) {
        final graphConfigsBuilder =
            store.state.gradesState.graphConfigs.toBuilder();
        for (var subject in loadedSubjects) {
          if (!graphConfigsBuilder.build().containsKey(subject.id)) {
            graphConfigsBuilder.update(
              (b) => b
                ..[subject.id] = SubjectGraphConfig((b) => b
                  ..thick = defaultThick
                  ..color = colors
                      .firstWhere(
                        (color) => !graphConfigsBuilder
                            .build()
                            .values
                            .any((config) => config.color == color.value),
                      )
                      .value),
            );
          }
        }
        store.dispatch(
            SetGraphConfigsAction(graphConfigsBuilder.build().toMap()));
        store.dispatch(SubjectsLoadedAction(loadedSubjects, lastRequested));
      }
    },
  );
}

TypedMiddleware<AppState, LoadSubjectDetailsAction> _createLoadDetail(
    Wrapper wrapper) {
  const String subjects = "api/student/subject_detail";

  return TypedMiddleware(
    (Store<AppState> store, LoadSubjectDetailsAction action,
        NextDispatcher next) async {
      final which = store.state.gradesState.semester;

      next(action);
      if (await wrapper.noInternet) {
        store.dispatch(NoInternetAction(true));
        return;
      }
      List<int> neededSemester = which.n != null ? [which.n] : [1, 2];
      int lastRequested;

      if (neededSemester
          .remove(lastRequested = store.state.gradesState.serverSemester)) {
        var data = await wrapper.post(subjects, {
          "studentId": store.state.config.userId,
          "subjectId": action.subject.id,
        });
        action.subject.subjects[lastRequested]
            .replaceWithSpecificData(data, lastRequested);
      }
      while (neededSemester.isNotEmpty) {
        await Requests.get(
            "https://vinzentinum.digitalesregister.it/v2/?semesterWechsel=${lastRequested = neededSemester.removeLast()}");
        var data = await wrapper.post(subjects, {
          "studentId": store.state.config.userId,
          "subjectId": action.subject.id
        });
        action.subject.subjects[lastRequested]
            .replaceWithSpecificData(data, lastRequested);
      }

      store.dispatch(SubjectsLoadedAction(
          store.state.gradesState.subjects.toList(), lastRequested));
    },
  );
}

TypedMiddleware<AppState, SwitchFutureAction> _createSwitchFuture() {
  return TypedMiddleware(
      (Store<AppState> store, SwitchFutureAction action, NextDispatcher next) {
    next(action);
    store.dispatch(LoadDaysAction(store.state.dayState.future));
  });
}

TypedMiddleware<AppState, LoginAction> _createLogin(Wrapper wrapper) {
  return TypedMiddleware(
    (Store<AppState> store, LoginAction action, NextDispatcher next) async {
      action = LoginAction(action.user.trim(), action.pass, action.fromStorage);
      next(action);
      if (action.user == "" || action.pass == "") {
        store.dispatch(LoginFailedAction("Bitte gib etwas ein",
            action.fromStorage, await wrapper.noInternet, action.user));
        return;
      }

      store.dispatch(LoggingInAction());
      await wrapper.login(
        action.user,
        action.pass,
        logout: () => store
            .dispatch(LogoutAction(store.state.settingsState.noPasswordSaving)),
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
    },
  );
}

TypedMiddleware<AppState, ShowLoginAction> _createShowLogin(Wrapper wrapper) {
  return TypedMiddleware((Store<AppState> store, ShowLoginAction action,
      NextDispatcher next) async {
    if (await wrapper.noInternet)
      store.dispatch(NoInternetAction(true));
    else
      store.dispatch(NoInternetAction(false));
    if (store.state.currentRouteIsLogin) return;
    navigatorKey.currentState.pushNamed("/login");
    store.dispatch(SetIsLoginRouteAction(true));
  });
}

TypedMiddleware<AppState, ShowNotificationsAction> _createShowNotifications() {
  return TypedMiddleware((Store<AppState> store, ShowNotificationsAction action,
      NextDispatcher next) async {
    navigatorKey.currentState.pushNamed("/notifications");
    next(action);
  });
}

TypedMiddleware<AppState, ShowSettingsAction> _createShowSettings() {
  return TypedMiddleware((Store<AppState> store, ShowSettingsAction action,
      NextDispatcher next) async {
    navigatorKey.currentState.pushNamed("/settings");
    next(action);
  });
}

TypedMiddleware<AppState, ShowCalendarAction> _createShowCalendar() {
  return TypedMiddleware((Store<AppState> store, ShowCalendarAction action,
      NextDispatcher next) async {
    navigatorKey.currentState.pushNamed("/calendar");
    next(action);
  });
}

TypedMiddleware<AppState, LoggedInAction> _createLoggedIn() {
  return TypedMiddleware((Store<AppState> store, LoggedInAction action,
      NextDispatcher next) async {
    if (!store.state.settingsState.noPasswordSaving && !action.fromStorage) {
      store.dispatch(SavePassAction());
    }
    final saveNoData =
        (await SharedPreferences.getInstance()).getBool("saveNoData") ?? false;
    store.dispatch(SetSaveNoDataAction(saveNoData));
    if (!saveNoData) {
      final vals = await _secureStorage.readAll();
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
      store.dispatch(
        MountAppStateAction(
          store.state.rebuild(
            (b) => b
              ..dayState = dayState.toBuilder()
              ..gradesState = gradesState.toBuilder()
              ..notificationState = notificationState.toBuilder()
              ..absenceState = absenceState?.toBuilder()
              ..calendarState = calendarState.toBuilder(),
          ),
        ),
      );
    }

    // next not at the beginning: bug fix (serialization)
    next(action);

    if (store.state.currentRouteIsLogin) {
      navigatorKey.currentState.pop();
      store.dispatch(SetIsLoginRouteAction(false));
    }
    store.dispatch(LoadDaysAction(true));
    store.dispatch(LoadNotificationsAction());
  });
}

TypedMiddleware<AppState, LogoutAction> _createLogout(Wrapper wrapper) {
  return TypedMiddleware(
      (Store<AppState> store, LogoutAction action, NextDispatcher next) {
    next(action);
    if (!store.state.settingsState.noPasswordSaving && action.hard) {
      store.dispatch(DeletePassAction());
    }
    wrapper.logout(hard: action.hard);
    store.dispatch(ShowLoginAction());
  });
}

TypedMiddleware<AppState, LoginFailedAction> _createLoginFailed() {
  return TypedMiddleware((Store<AppState> store, LoginFailedAction action,
      NextDispatcher next) async {
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
  });
}

TypedMiddleware<AppState, SetSaveNoPassAction> _createSetSaveNoPass(
    Wrapper wrapper) {
  return TypedMiddleware((Store<AppState> store, SetSaveNoPassAction action,
      NextDispatcher next) async {
    next(action);
    wrapper.safeMode = action.noSave;
    (await SharedPreferences.getInstance()).setBool("safeMode", action.noSave);
    if (action.noSave && !store.state.settingsState.noDataSaving) {
      store.dispatch(SetSaveNoDataAction(true));
    }
    if (!store.state.loginState.loggedIn) return;
    if (!action.noSave) {
      store.dispatch(SavePassAction());
    } else
      store.dispatch(DeletePassAction());
  });
}

TypedMiddleware<AppState, SavePassAction> _createSavePass(Wrapper wrapper) {
  return TypedMiddleware((Store<AppState> store, SavePassAction action,
      NextDispatcher next) async {
    next(action);
    _secureStorage.write(key: "user", value: wrapper.user);
    _secureStorage.write(key: "pass", value: wrapper.pass);
  });
}

TypedMiddleware<AppState, DeletePassAction> _createDeletePass() {
  return TypedMiddleware((Store<AppState> store, DeletePassAction action,
      NextDispatcher next) async {
    next(action);
    _secureStorage.deleteAll();
  });
}

TypedMiddleware<AppState, NoInternetAction> _createNoInternet() {
  return TypedMiddleware(
      (Store<AppState> store, NoInternetAction action, NextDispatcher next) {
    if (action.noInternet) Fluttertoast.showToast(msg: "Kein Internet");
    next(action);
  });
}

TypedMiddleware<AppState, DeleteNotificationAction> _createDeleteNotification(
    Wrapper wrapper) {
  return TypedMiddleware((Store<AppState> store,
      DeleteNotificationAction action, NextDispatcher next) async {
    if (await wrapper.noInternet) {
      store.dispatch(NoInternetAction(true));
      return;
    }
    next(action);

    wrapper.post(
        "api/notification/markAsRead", {"id": action.notification.id}, false);
  });
}

TypedMiddleware<AppState, DeleteAllNotificationsAction>
    _createDeleteAllNotifications(Wrapper wrapper) {
  return TypedMiddleware((Store<AppState> store,
      DeleteAllNotificationsAction action, NextDispatcher next) async {
    if (await wrapper.noInternet) {
      store.dispatch(NoInternetAction(true));
      return;
    }
    next(action);
    wrapper.post("api/notification/markAsRead", {}, false);
  });
}

TypedMiddleware<AppState, ShowGradesAction> _createShowGradesPageAction() {
  return TypedMiddleware(
      (Store<AppState> store, ShowGradesAction action, NextDispatcher next) {
    navigatorKey.currentState.pushNamed("/grades");
    store.dispatch(LoadSubjectsAction());
    next(action);
  });
}

TypedMiddleware<AppState, ShowAbsencesAction> _createShowAbsencesPageAction() {
  return TypedMiddleware(
      (Store<AppState> store, ShowAbsencesAction action, NextDispatcher next) {
    navigatorKey.currentState.pushNamed("/absences");
    store.dispatch(LoadAbsencesAction());
    next(action);
  });
}

TypedMiddleware<AppState, ShowFullscreenChartAciton>
    _createShowGradesChartPageAction() {
  return TypedMiddleware((Store<AppState> store,
      ShowFullscreenChartAciton action, NextDispatcher next) {
    navigatorKey.currentState.pushNamed("/gradesChart");
    next(action);
  });
}

TypedMiddleware<AppState, SetGradesSemesterAction>
    _createSetGradesSemesterMiddleware() {
  return TypedMiddleware((Store<AppState> store, SetGradesSemesterAction action,
      NextDispatcher next) {
    next(action);
    store.dispatch(LoadSubjectsAction());
  });
}

var call = 0;
var lastSaving = DateTime(0);

_saveStateMiddleware(Store<AppState> store, action, NextDispatcher next) async {
  final stateBefore = store.state;
  next(action);
  if (store.state.loginState.loggedIn &&
      store.state.loginState.userName != null &&
      stateBefore != store.state) {
    if (!store.state.settingsState.noDataSaving) {
      final _call = ++call;
      final delay = lastSaving.difference(DateTime.now()).inSeconds < 5
          ? Duration()
          : Duration(seconds: 5);
      await Future.delayed(delay, () async {
        if (_call < call) {
          return;
        }
        lastSaving = DateTime.now();
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

void _addReminderMiddleware(Store<AppState> store, AddReminderAction action,
    next, Wrapper wrapper) async {
  next(action);

  final result = await wrapper.post("api/student/dashboard/save_reminder", {
    "date": DateFormat("yyyy-MM-dd").format(action.date),
    "text": action.msg,
  });
  if (result == null) {
    if (await wrapper.noInternet) {
      store.dispatch(NoInternetAction(true));
      return;
    }
    Fluttertoast.showToast(msg: "Beim Speichern ist ein Fehler aufgetreten");
    return;
  }
  store.dispatch(
    HomeworkAddedAction(
      Homework.parse(
        result,
      ),
      action.date,
    ),
  );
}

void _deleteHomework(Store<AppState> store, DeleteHomeworkAction action, next,
    Wrapper wrapper) async {
  next(action);

  final result = await wrapper.post("api/student/dashboard/delete_reminder", {
    "id": action.hw.id,
  });
  if (result != null && result["success"]) {
    // already called next
  } else {
    next(HomeworkAddedAction(action.hw, action.date));
    if (await wrapper.noInternet) {
      store.dispatch(NoInternetAction(true));
      return;
    }
    Fluttertoast.showToast(msg: "Beim Speichern ist ein Fehler aufgetreten");
    return;
  }
}

void _toggleDone(Store<AppState> store, ToggleDoneAction action, next,
    Wrapper wrapper) async {
  next(action);
  final result = await wrapper.post("api/student/dashboard/toggle_reminder", {
    "id": action.hw.id,
    "type": action.hw.type.name,
    "value": action.done,
  });
  if (result != null && result["success"]) {
    next(
        action); // duplicate - protection from multiple, failing and not failing requests
  } else {
    next(ToggleDoneAction(action.hw, !action.hw.checked));
    if (await wrapper.noInternet) {
      store.dispatch(NoInternetAction(true));
      return;
    }
    Fluttertoast.showToast(msg: "Beim Speichern ist ein Fehler aufgetreten");
    return;
  }
}

void _loadAbsences(Store<AppState> store, LoadAbsencesAction action, next,
    Wrapper wrapper) async {
  next(action);
  final response = await wrapper.post("api/student/dashboard/absences");
  if (response != null) {
    store.dispatch(AbsencesLoadedAction(response));
  }
}
