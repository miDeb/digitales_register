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
    final now = DateTime.now();
    for (var day in List.of(allDays)) {
      final newDay = action.loadedDays.build().firstWhere(
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
        continue;
      }
      action.loadedDays.remove(newDay);
      for (var oldHw in day.homework.toList()) {
        final newHw = newDay.homework.firstWhere(
          (d) => d.id == oldHw.id,
          orElse: () => null,
        );
        if (newHw == null) {
          day.homework.remove(oldHw);
          day.deletedHomework.add(Homework.parse(oldHw.toJson())
            ..deleted = true
            ..isChanged = action.markNewOrChangedEntries
            ..previousVersion = oldHw
            ..lastNotSeen = day.lastRequested
            ..firstSeen = now);
        } else if (!newHw.equalsIgnoreCustom(oldHw)) {
          day.homework.remove(oldHw);
          day.homework.add(newHw
            ..previousVersion = oldHw
            ..lastNotSeen = day.lastRequested
            ..firstSeen = now
            ..isChanged = action.markNewOrChangedEntries);
        } else {
          oldHw.checked = newHw.checked;
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
            ..firstSeen = now
            ..isChanged = action.markNewOrChangedEntries);
        } else {
          day.homework.add(newHw
            ..lastNotSeen = day.lastRequested
            ..firstSeen = now
            ..isNew = newHw.type != HomeworkType.grade &&
                newHw.type != HomeworkType.homework &&
                action.markNewOrChangedEntries);
        }
      }
      day.lastRequested = now;
    }
    for (var newDay in action.loadedDays.build()) {
      allDays.add(newDay
        ..lastRequested = now
        ..homework.forEach((h) => h.firstSeen = now));
    }
    allDays.sort((a, b) => a.date.compareTo(b.date));
    return state
      ..allDays = ListBuilder(allDays)
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
    return state..future = !state.future;
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

TypedReducer<DayStateBuilder, MarkAsNotNewOrChangedAction>
    _createMarkAsNotNewOrChangedReducer() {
  return TypedReducer(
      (DayStateBuilder state, MarkAsNotNewOrChangedAction action) {
    action.homework
      ..isChanged = false
      ..isNew = false;
    return state;
  });
}

TypedReducer<DayStateBuilder, MarkAllAsNotNewOrChangedAction>
    _createMarkAllAsNotNewOrChangedReducer() {
  return TypedReducer(
      (DayStateBuilder state, MarkAllAsNotNewOrChangedAction action) {
    return state
      ..allDays.map((day) => day
        ..homework.forEach((homework) => homework
          ..isChanged = false
          ..isNew = false));
  });
}

TypedReducer<DayStateBuilder, UpdateHomeworkFilterBlacklistAction>
    _createUpdateBlacklistReducer() {
  return TypedReducer(
      (DayStateBuilder state, UpdateHomeworkFilterBlacklistAction action) {
    return state..blacklist = ListBuilder(action.blacklist);
  });
}
