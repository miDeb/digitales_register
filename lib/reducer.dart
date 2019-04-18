import 'package:built_collection/built_collection.dart';
import 'package:redux/redux.dart';

import 'actions.dart';
import 'app_state.dart';
import 'data.dart';

Reducer<AppState> appReducer = (AppState state, action) {
  if (action is MountAppStateAction) {
    return action.appState;
  }
  final newState = AppState((builder) {
    builder
      ..dayState = dayReducer(state.dayState.toBuilder(), action)
      ..loginState = _loginReducer(state.loginState.toBuilder(), action)
      ..noInternet = _noInternetReducer(state.noInternet, action)
      ..notificationState =
          _notificationsReducer(state.notificationState.toBuilder(), action)
      ..currentRouteIsLogin =
          _createCurrentRouteReducer()(state.currentRouteIsLogin, action)
      ..config = _configReducer(state.config?.toBuilder(), action)
      ..gradesState = _gradesReducer(state.gradesState.toBuilder(), action)
      ..settingsState =
          _settingsStateReducer(state.settingsState.toBuilder(), action)
      ..absenceState = _absenceReducer(state.absenceState?.toBuilder(), action)
      ..calendarState =
          _calendarReducer(state.calendarState?.toBuilder(), action);
  });
  return newState;
};

SettingsStateBuilder _settingsStateReducer(SettingsStateBuilder state, action) {
  return action is SettingsLoadedAction
      ? action.state.toBuilder()
      : (state
        ..noDataSaving = _saveDataReducer(state.noDataSaving, action)
        ..noPasswordSaving = _savePassReducer(state.noPasswordSaving, action)
        ..askWhenDelete = _askWhenDeleteReducer(state.askWhenDelete, action)
        ..doubleTapForDone =
            _doubleTapForDoneReducer(state.doubleTapForDone, action)
        ..noAverageForAllSemester =
            _noAvgForAllReducer(state.noAverageForAllSemester, action)
        ..showCancelled = _showCancelledReducer(state.showCancelled, action)
        ..typeSorted = _sortByTypeReducer(state.typeSorted, action));
}

final _noInternetReducer =
    TypedReducer<bool, NoInternetAction>((_, action) => action.noInternet);

final dayReducer = combineReducers<DayStateBuilder>([
  _createDaysLoadedReducer(),
  _createDaysLoadingReducer(),
  _createToggleFutureReducer(),
  _createDaysNotLoadedReducer(),
  _createHomeworkAddedReducer(),
  _createHomeworkRemovedReducer(),
  _createToggleHomeworkDoneReducer(),
]);

final _loginReducer = combineReducers<LoginStateBuilder>([
  _createLoginFailedReducer(),
  _createLoginSucceededReducer(),
  _createLoggingInReducer(),
  _createLogoutReducer(),
]);

final _notificationsReducer = combineReducers<NotificationStateBuilder>([
  _createNotificationsLoadedReducer(),
  _createDeleteNotificationReducer(),
  _createDeleteAllNotificationsReducer(),
]);

final _absenceReducer =
    TypedReducer<AbsenceStateBuilder, AbsencesLoadedAction>((state, action) {
  return parseAbsences(action.absences);
});

AbsenceStateBuilder parseAbsences(json) {
  final rawStats = json["statistics"];
  final stats = AbsenceStatisticBuilder()
    ..counter = rawStats["counter"]
    ..counterForSchool = rawStats["counterForSchool"]
    ..delayed = rawStats["delayed"]
    ..justified = rawStats["justified"]
    ..notJustified = rawStats["notJustified"]
    ..percentage = rawStats["percentage"];
  final absences = (json["absences"] as List).map((g) {
    return AbsenceGroup(
      (b) => b
        ..justified = AbsenceJustified.fromInt(g["justified"])
        ..reasonSignature = g["reason_signature"]
        ..reasonTimestamp = DateTime.parse(g["reason_timestamp"])
        ..reason = g["reason"]
        ..absences = ListBuilder(
          (g["group"] as List).map(
            (a) {
              return Absence(
                (b) => b
                  ..minutes = a["minutes"]
                  ..date = DateTime.parse(a["date"])
                  ..hour = a["hour"]
                  ..minutesCameTooLate = a["minutes_begin"]
                  ..minutesLeftTooEarly = a["minutes_end"],
              );
            },
          ),
        )
        ..minutes = b.absences.build().fold(0, (min, a) {
          if (a.minutes != 50) {
            min += a.minutesCameTooLate + a.minutesLeftTooEarly;
          }
          return min;
        })
        ..hours = b.absences.build().fold(0, (h, a) {
          if (a.minutes == 50) {
            h++;
          }
          return h;
        }),
    );
  });
  return AbsenceStateBuilder()
    ..statistic = stats
    ..absences = ListBuilder(absences);
}

final _calendarReducer = combineReducers<CalendarStateBuilder>([
  _calendarLoadedReducer.call,
  _calendarDaySetReducer.call,
]);

final _calendarLoadedReducer =
    TypedReducer<CalendarStateBuilder, CalendarLoadedAction>(
        (CalendarStateBuilder state, CalendarLoadedAction action) {
  final t = (action.result as Map).map((k, e) {
    final date = DateTime.parse(k);
    return MapEntry(date, parseCalendarDay(e, date).build());
  });
  return state..days.addAll(t);
});

final _calendarDaySetReducer =
    TypedReducer<CalendarStateBuilder, CurrentMondayChangedAction>(
        (state, action) {
  return state..currentMonday = action.monday;
});

CalendarDayBuilder parseCalendarDay(day, DateTime date) {
  return CalendarDayBuilder()
    ..date = date
    ..hours = ListBuilder(((day as Map).values.toList()
          ..removeWhere((e) => e == null)
          ..sort((a, b) => a["hour"].compareTo(b["hour"])))
        .map((h) => parseHour(h).build()));
}

CalendarHourBuilder parseHour(hour) {
  return CalendarHourBuilder()
    ..description = hour["description"]
    ..exam = hour["exam"]["name"]
    ..fromHour = hour["hour"]
    ..toHour = hour["toHour"]
    ..homework = hour["homework"]["name"] ?? ""
    ..rooms = ListBuilder((hour["rooms"] as List).map((r) => r["name"]))
    ..subject = hour["subject"]["name"]
    ..teachers = ListBuilder((hour["teachers"] as List)
        .map((r) => "${r["firstName"]} ${r["lastName"]}"));
}

final _savePassReducer =
    TypedReducer((bool safeMode, SetSaveNoPassAction action) => action.noSave);

final _askWhenDeleteReducer =
    TypedReducer((bool ask, SetAskWhenDeleteAction action) => action.ask);
final _noAvgForAllReducer =
    TypedReducer((bool noAvg, SetNoAverageForAllAction action) => action.noAvg);
final _showCancelledReducer = TypedReducer(
    (bool showCancelled, SetGradesShowCancelledAction action) =>
        action.showCancelled);
final _doubleTapForDoneReducer = TypedReducer(
    (bool enabled, SetDoubleTapForDoneAction action) => action.enabled);
final _sortByTypeReducer = TypedReducer(
    (bool typeSorted, SetGradesTypeSortedAction action) => action.typeSorted);
final _saveDataReducer =
    TypedReducer((bool safeMode, SetSaveNoDataAction action) => action.noSave);

final _gradesReducer = combineReducers<GradesStateBuilder>([
  _loadSubjectsReducer,
  TypedReducer<GradesStateBuilder, SetGraphConfigsAction>(
      _setGradesGraphConfigRecuder),
  TypedReducer<GradesStateBuilder, SubjectsLoadedAction>(
      _subjectsLoadedReducer),
  TypedReducer<GradesStateBuilder, SetGradesSemesterAction>(
      _setGradesSemesterReducer),
  TypedReducer<GradesStateBuilder, LoggedInAgainAutomatically>(
    _afterAutoRelogin,
  ),
]);

TypedReducer<bool, SetIsLoginRouteAction> _createCurrentRouteReducer() {
  return TypedReducer((bool state, SetIsLoginRouteAction action) {
    return action.isLogin;
  });
}

final _configReducer = TypedReducer(
    (ConfigBuilder config, SetConfigAction action) =>
        (config ?? ConfigBuilder())..replace(action.config));

TypedReducer<LoginStateBuilder, LoginFailedAction> _createLoginFailedReducer() {
  return TypedReducer((LoginStateBuilder state, LoginFailedAction action) {
    return state
      ..errorMsg = action.cause
      ..userName = action.username
      ..loading = false
      ..loggedIn = false;
  });
}

TypedReducer<LoginStateBuilder, LoggedInAction> _createLoginSucceededReducer() {
  return TypedReducer((LoginStateBuilder state, LoggedInAction action) {
    return state
      ..errorMsg = null
      ..userName = action.userName
      ..loading = false
      ..loggedIn = true;
  });
}

TypedReducer<LoginStateBuilder, LoggingInAction> _createLoggingInReducer() {
  return TypedReducer((LoginStateBuilder state, LoggingInAction action) {
    return state
      ..loading = true
      ..loggedIn = false;
  });
}

TypedReducer<LoginStateBuilder, LogoutAction> _createLogoutReducer() {
  return TypedReducer((LoginStateBuilder state, LogoutAction action) {
    return state
      ..loggedIn = false
      ..userName = null;
  });
}

TypedReducer<DayStateBuilder, DaysLoadedAction> _createDaysLoadedReducer() {
  return TypedReducer((DayStateBuilder state, DaysLoadedAction action) {
    final allDays = state.allDays.build().toList();
    final now = DateTime.now();
    for (var day in allDays) {
      final newDay = action.loadedDays.firstWhere(
        (d) => d.date == day.date,
        orElse: () => null,
      );
      action.loadedDays.remove(newDay);
      if (newDay == null) continue;
      for (var oldHw in day.homework.toList()) {
        final newHw = newDay.homework.firstWhere(
          (d) => d.id == oldHw.id,
          orElse: () => null,
        );
        if (newHw == null) {
          day.homework.remove(oldHw);
          day.homework.add(Homework.parse(oldHw.toJson())
            ..deleted = true
            ..previousVersion = oldHw
            ..lastNotSeen = day.lastRequested
            ..firstSeen = now);
        } else if (newHw != oldHw) {
          day.homework.remove(oldHw);
          day.homework.add(newHw
            ..previousVersion = oldHw
            ..lastNotSeen = day.lastRequested
            ..firstSeen = now);
        }
        newDay.homework.remove(newHw);
      }
      for (var newHw in newDay.homework) {
        final deletedHw = day.deletedHomework.firstWhere(
          (d) => d.id == newHw.id,
          orElse: () => null,
        );
        if (deletedHw != null) {
          day.deletedHomework.remove(deletedHw);
          day.homework.add(newHw
            ..previousVersion = deletedHw
            ..lastNotSeen = day.lastRequested
            ..firstSeen = now);
        } else {
          day.homework.add(newHw
            ..lastNotSeen = day.lastRequested
            ..firstSeen = now);
        }
      }
      day.lastRequested = now;
    }
    for (var newDay in action.loadedDays) {
      allDays.add(newDay
        ..lastRequested = now
        ..homework.forEach((h) => h.firstSeen = now));
    }
    allDays.sort((a, b) => a.date.compareTo(b.date));
    return state
      ..allDays = ListBuilder(allDays)
      ..displayDays = ListBuilder(Day.filterFuture(allDays, state.future))
      ..loading = false;
  });
}

TypedReducer<DayStateBuilder, DaysNotLoadedAction>
    _createDaysNotLoadedReducer() {
  return TypedReducer((DayStateBuilder state, DaysNotLoadedAction action) {
    return state..loading = false;
  });
}

TypedReducer<DayStateBuilder, LoadDaysAction> _createDaysLoadingReducer() {
  return TypedReducer((DayStateBuilder state, LoadDaysAction action) {
    return state..loading = true;
  });
}

TypedReducer<DayStateBuilder, SwitchFutureAction> _createToggleFutureReducer() {
  return TypedReducer((DayStateBuilder state, SwitchFutureAction action) {
    return state
      ..displayDays = ListBuilder(
          Day.filterFuture(state.allDays.build().toList(), !state.future))
      ..future = !state.future;
  });
}

TypedReducer<DayStateBuilder, HomeworkAddedAction>
    _createHomeworkAddedReducer() {
  return TypedReducer((DayStateBuilder state, HomeworkAddedAction action) {
    return state
      ..allDays.map((day) =>
          day.date == action.date ? (day..homework.add(action.hw)) : day);
  });
}

TypedReducer<DayStateBuilder, DeleteHomeworkAction>
    _createHomeworkRemovedReducer() {
  return TypedReducer((DayStateBuilder state, DeleteHomeworkAction action) {
    return state..allDays.map((day) => day..homework.remove(action.hw));
  });
}

TypedReducer<DayStateBuilder, ToggleDoneAction>
    _createToggleHomeworkDoneReducer() {
  return TypedReducer((DayStateBuilder state, ToggleDoneAction action) {
    action.hw.checked = action.done;
    return state;
  });
}

TypedReducer<NotificationStateBuilder, NotificationsLoadedAction>
    _createNotificationsLoadedReducer() {
  return TypedReducer(
      (NotificationStateBuilder state, NotificationsLoadedAction action) {
    return state..notifications = ListBuilder(action.notifications);
  });
}

TypedReducer<NotificationStateBuilder, DeleteNotificationAction>
    _createDeleteNotificationReducer() {
  return TypedReducer(
      (NotificationStateBuilder state, DeleteNotificationAction action) {
    return state..notifications.remove(action.notification);
  });
}

TypedReducer<NotificationStateBuilder, DeleteAllNotificationsAction>
    _createDeleteAllNotificationsReducer() {
  return TypedReducer(
      (NotificationStateBuilder state, DeleteAllNotificationsAction action) {
    return state..notifications.clear();
  });
}

GradesStateBuilder _loadSubjectsReducer(GradesStateBuilder state, action) {
  if (action is LoadSubjectsAction) {
    return state..loading = true;
  } else if (action is NoInternetAction) {
    return state..loading = false;
  } else
    return state;
}

GradesStateBuilder _subjectsLoadedReducer(
    GradesStateBuilder state, SubjectsLoadedAction action) {
  return state
    ..subjects = ListBuilder(action.subjects)
    ..serverSemester = action.lastRequestedSemester
    ..loading = false;
}

GradesStateBuilder _setGradesGraphConfigRecuder(
    GradesStateBuilder state, SetGraphConfigsAction action) {
  return state..graphConfigs.replace(action.configs);
}

GradesStateBuilder _setGradesSemesterReducer(
    GradesStateBuilder state, SetGradesSemesterAction action) {
  return state..semester.replace(action.newSemester);
}

GradesStateBuilder _afterAutoRelogin(
    GradesStateBuilder state, LoggedInAgainAutomatically action) {
  return state..serverSemester = null;
}
