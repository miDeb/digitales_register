import 'package:built_collection/built_collection.dart';
import 'package:redux/redux.dart';

import '../actions.dart';
import '../app_state.dart';
import '../data.dart';

final dayReducer = combineReducers<DayStateBuilder>([
  _createDaysLoadedReducer(),
  _createDaysLoadingReducer(),
  _createToggleFutureReducer(),
  _createDaysNotLoadedReducer(),
  _createHomeworkAddedReducer(),
  _createHomeworkRemovedReducer(),
  _createToggleHomeworkDoneReducer(),
  _createMarkAsNotNewOrChangedReducer(),
  _createMarkAllAsNotNewOrChangedReducer(),
  _createUpdateBlacklistReducer(),
]);
TypedReducer<DayStateBuilder, DaysLoadedAction> _createDaysLoadedReducer() {
  return TypedReducer((DayStateBuilder state, DaysLoadedAction action) {
    final allDays = state.allDays.build().toList();

    List<Day> loadedDays = List.from(action.data.map(
      (d) => _parseDay(d),
    ));

    final now = DateTime.now();
    for (var day in List.of(allDays)) {
      day.rebuild((b) {
        final newDay = loadedDays.firstWhere(
          (d) => d.date == day.date,
          orElse: () => null,
        );
        if (newDay == null) {
          if (!action.future &&
              day.date.isBefore(
                DateTime.now().subtract(Duration(
                    days: 1)), // subtract to not accidentally delete today
              )) {
            allDays.remove(day);
          }
          return;
        }
        loadedDays.remove(newDay);
        final newHomework = newDay.homework.toList();
        for (var oldHw in day.homework.toList()) {
          final newHw = newHomework.firstWhere(
            (d) => d.id == oldHw.id,
            orElse: () => null,
          );
          if (newHw == null) {
            b.homework.remove(oldHw);
            b.deletedHomework.add(oldHw.rebuild((b) => b
              ..deleted = true
              ..isChanged = action.markNewOrChangedEntries
              ..previousVersion = oldHw.toBuilder()
              ..lastNotSeen = day.lastRequested
              ..firstSeen = now));
          } else if (newHw != oldHw) {
            b.homework.remove(oldHw);
            b.homework.add(newHw.rebuild((b) => b
              ..previousVersion = oldHw.toBuilder()
              ..lastNotSeen = day.lastRequested
              ..firstSeen = now
              ..isChanged = action.markNewOrChangedEntries));
          } else {
            b.homework[b.homework.build().indexOf(oldHw)] =
                oldHw.rebuild((b) => b..checked = newHw.checked);
          }
          newHomework.remove(newHw);
        }
        for (var newHw in newHomework) {
          final deletedHw = day.deletedHomework.firstWhere(
            (d) => d.id == newHw.id,
            orElse: () => null,
          );
          if (deletedHw != null) {
            b.deletedHomework.remove(deletedHw);
            b.homework.add(newHw.rebuild((b) => b
              ..previousVersion = deletedHw.toBuilder()
              ..lastNotSeen = day.lastRequested
              ..firstSeen = now
              ..isChanged = action.markNewOrChangedEntries));
          } else {
            b.homework.add(newHw.rebuild((b) => b
              ..lastNotSeen = day.lastRequested
              ..firstSeen = now
              ..isNew = newHw.type != HomeworkType.grade &&
                  newHw.type != HomeworkType.homework &&
                  action.markNewOrChangedEntries));
          }
        }
        b.lastRequested = now;
      });
    }
    for (var newDay in loadedDays) {
      allDays.add(newDay.rebuild((b) => b
        ..lastRequested = now
        ..homework.map((h) => h.rebuild((b) => b..firstSeen = now))));
    }
    allDays.sort((a, b) => a.date.compareTo(b.date));
    return state
      ..allDays = ListBuilder(allDays)
      ..loading = false;
  });
}

Day _parseDay(data) {
  return Day((b) => b
    ..date = DateTime.parse(data["date"])
    ..homework = ListBuilder((List<Map<String, dynamic>>.from(data["items"]))
        .map((m) => _parseHomework(m))));
}

Homework _parseHomework(data) {
  return Homework((b) {
    b
      ..id = data["id"]
      ..title = data["title"]
      ..subtitle = data["subtitle"]
      ..label = data["label"]
      ..warning = data["warning"] ?? b.warning
      ..checkable = data["checkable"] ?? b.checkable
      ..checked = data["checked"] is bool
          ? data["checked"]
          : (data["checked"] ?? 0) != 0
      ..deleteable = data["deleteable"] ?? b.deleteable;

    final typeString = data["type"];
    HomeworkType type;
    switch (typeString) {
      case "lessonHomework":
        type = HomeworkType.lessonHomework;
        break;
      case "gradeGroup":
        type = HomeworkType.gradeGroup;
        break;
      case "grade":
        type = HomeworkType.grade;
        break;
      case "observation":
        type = HomeworkType.observation;
        break;
      case "homework":
        type = HomeworkType.homework;
        break;
      default:
        type = HomeworkType.unknown;
        break;
    }
    b..type = type;

    if (type == HomeworkType.grade) {
      b..gradeFormatted = formatGrade(data["grade"]);
      b..grade = data["grade"];
    }
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
    return state..future = !state.future;
  });
}

TypedReducer<DayStateBuilder, HomeworkAddedAction>
    _createHomeworkAddedReducer() {
  return TypedReducer((DayStateBuilder state, HomeworkAddedAction action) {
    return state
      ..allDays.map((day) => day.date == action.date
          ? day.rebuild((b) => b..homework.add(_parseHomework(action.data)))
          : day);
  });
}

TypedReducer<DayStateBuilder, DeleteHomeworkAction>
    _createHomeworkRemovedReducer() {
  return TypedReducer((DayStateBuilder state, DeleteHomeworkAction action) {
    return state
      ..allDays.map((day) => day.rebuild((b) => b..homework.remove(action.hw)));
  });
}

TypedReducer<DayStateBuilder, ToggleDoneAction>
    _createToggleHomeworkDoneReducer() {
  return TypedReducer((DayStateBuilder state, ToggleDoneAction action) {
    return state
      ..allDays.map((day) => day.homework.contains(action.hw)
          ? day.rebuild((b) => b
            ..homework[day.homework.indexOf(action.hw)] =
                action.hw.rebuild((hb) => hb..checked = action.done))
          : day);
  });
}

TypedReducer<DayStateBuilder, MarkAsNotNewOrChangedAction>
    _createMarkAsNotNewOrChangedReducer() {
  return TypedReducer(
      (DayStateBuilder state, MarkAsNotNewOrChangedAction action) {
    return state
      ..allDays.map((day) => day.homework.contains(action.homework)
          ? day.rebuild((b) => b
            ..homework[day.homework.indexOf(action.homework)] =
                action.homework.rebuild((hb) => hb
                  ..isChanged = false
                  ..isNew = false))
          : day);
  });
}

TypedReducer<DayStateBuilder, MarkAllAsNotNewOrChangedAction>
    _createMarkAllAsNotNewOrChangedReducer() {
  return TypedReducer(
      (DayStateBuilder state, MarkAllAsNotNewOrChangedAction action) {
    return state
      ..allDays.map(
        (day) => day
          ..homework.map(
            (homework) => homework.rebuild((b) => b
              ..isChanged = false
              ..isNew = false),
          ),
      );
  });
}

TypedReducer<DayStateBuilder, UpdateHomeworkFilterBlacklistAction>
    _createUpdateBlacklistReducer() {
  return TypedReducer(
      (DayStateBuilder state, UpdateHomeworkFilterBlacklistAction action) {
    return state..blacklist = ListBuilder(action.blacklist);
  });
}
