// Copyright (C) 2021 Michael Debertol
//
// This file is part of digitales_register.
//
// digitales_register is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// digitales_register is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with digitales_register.  If not, see <http://www.gnu.org/licenses/>.

import 'dart:developer';

import 'package:built_collection/built_collection.dart';
import 'package:built_redux/built_redux.dart';
import 'package:collection/collection.dart' show IterableExtension;

import 'package:dr/actions/dashboard_actions.dart';
import 'package:dr/app_state.dart';
import 'package:dr/data.dart';
import 'package:dr/utc_date_time.dart';
import 'package:dr/util.dart';

final dashboardReducerBuilder = NestedReducerBuilder<AppState, AppStateBuilder,
    DashboardState, DashboardStateBuilder>(
  (s) => s.dashboardState,
  (b) => b.dashboardState,
)
  ..add(DashboardActionsNames.loaded, _loaded)
  ..add(DashboardActionsNames.load, _loading)
  ..add(DashboardActionsNames.switchFuture, _switchFuture)
  ..add(DashboardActionsNames.notLoaded, _notLoaded)
  ..add(DashboardActionsNames.homeworkAdded, _homeworkAdded)
  ..add(DashboardActionsNames.deleteHomework, _homeworkRemoved)
  ..add(DashboardActionsNames.toggleDone, _toggleDone)
  ..add(DashboardActionsNames.markAsSeen, _markAsSeen)
  ..add(DashboardActionsNames.markDeletedHomeworkAsSeen,
      _markDeletedHomeworkAsSeen)
  ..add(DashboardActionsNames.markAllAsSeen, _markAllAsSeen)
  ..add(DashboardActionsNames.updateBlacklist, _updateBlacklist)
  ..add(DashboardActionsNames.downloadAttachment, _downloadAttachment)
  ..add(DashboardActionsNames.attachmentReady, _attachmentReady);

void _loaded(DashboardState state, Action<DaysLoadedPayload> action,
    DashboardStateBuilder builder) {
  final loadTime = now;
  final loadedDays = [
    for (final day in action.payload.data as Iterable)
      tryParse<Day, dynamic>(
          day,
          (dynamic day) =>
              _parseDay(getMap(day)!, action.payload.deduplicateEntries))
  ];

  final List<Day> daysToDelete = [];
  // Due to a bug some days might have been duplicated.
  // TODO: Remove this once we are confident no users migrate from an affected version anymore.
  final Set<UtcDateTime> seenDates = {};

  builder.allDays.map(
    (day) => day.rebuild(
      (b) {
        final newDay = loadedDays.firstWhereOrNull(
          (d) => d.date.stripTime() == day.date.stripTime(),
        );
        if (seenDates.contains(day.date.stripTime())) {
          daysToDelete.add(day);
        } else {
          seenDates.add(day.date.stripTime());
        }
        if (newDay == null) {
          if (!action.payload.future &&
              day.date.isBefore(
                loadTime.subtract(
                  const Duration(days: 1),
                ), // subtract to not accidentally delete today
              )) {
            daysToDelete.add(day);
          }
          return;
        }
        loadedDays.remove(newDay);
        final List<Homework> newHomework = newDay.homework.toList();
        for (final oldHw in day.homework.toList()) {
          // look if there is any matching id first,
          // then look for other similarities
          final newHw = newHomework.firstWhereOrNull(
                (d) => d.id == oldHw.id,
              ) ??
              newHomework.firstWhereOrNull(
                (d) => d.isSuccessorOf(oldHw),
              );
          if (newHw == null) {
            b.homework.remove(oldHw);
            if (oldHw.type != HomeworkType.homework) {
              b.deletedHomework.add(
                oldHw.rebuild((b) => b
                  ..deleted = true
                  ..isChanged = action.payload.markNewOrChangedEntries
                  ..previousVersion = oldHw.toBuilder()
                  ..lastNotSeen = day.lastRequested
                  ..firstSeen = loadTime),
              );
            }
          } else if (!newHw.serverEquals(oldHw)) {
            b.homework.remove(oldHw);
            b.homework.add(newHw.rebuild((b) => b
              ..previousVersion = oldHw.toBuilder()
              ..lastNotSeen = day.lastRequested
              ..firstSeen = loadTime
              ..isChanged = action.payload.markNewOrChangedEntries &&
                  // there was already a notification in this case (new grade)
                  !(oldHw.type == HomeworkType.gradeGroup &&
                      newHw.type == HomeworkType.grade)));
          } else {
            // preserve client-custom data, but update everything else
            final mergedHw = newHw.toBuilder()
              ..firstSeen = oldHw.firstSeen
              ..lastNotSeen = oldHw.lastNotSeen
              ..previousVersion = oldHw.previousVersion?.toBuilder();
            mergedHw.gradeGroupSubmissions.map(
              (ggs) => ggs.rebuild(
                (ggs) => ggs.fileAvailable = oldHw.gradeGroupSubmissions?.any(
                      (oldGgs) => oldGgs.file == ggs.file,
                    ) ??
                    false,
              ),
            );
            b.homework[b.homework.build().indexOf(oldHw)] = mergedHw.build();
          }
          newHomework.remove(newHw);
        }
        for (final newHw in newHomework) {
          final deletedHw = day.deletedHomework.firstWhereOrNull(
                (d) => d.id == newHw.id,
              ) ??
              day.deletedHomework.firstWhereOrNull(
                (d) => d.isSuccessorOf(newHw),
              );
          if (deletedHw != null) {
            b.deletedHomework.remove(deletedHw);
            b.homework.add(newHw.rebuild((b) => b
              ..previousVersion = deletedHw.toBuilder()
              ..lastNotSeen = day.lastRequested
              ..firstSeen = loadTime
              ..isChanged = action.payload.markNewOrChangedEntries));
          } else {
            b.homework.add(newHw.rebuild((b) => b
              ..lastNotSeen = day.lastRequested
              ..firstSeen = loadTime
              ..isNew = newHw.type != HomeworkType.grade &&
                  newHw.type != HomeworkType.homework &&
                  action.payload.markNewOrChangedEntries));
          }
        }
        b.lastRequested = loadTime;
      },
    ),
  );
  builder.allDays.removeWhere((day) => daysToDelete.contains(day));

  for (final newDay in loadedDays) {
    builder.allDays.add(newDay.rebuild((b) => b
      ..lastRequested = loadTime
      ..homework.map((h) => h.rebuild((b) => b..firstSeen = loadTime))));
  }
  builder.allDays.sort((a, b) => a.date.compareTo(b.date));
  builder.loading = false;
}

Day _parseDay(Map data, bool deduplicate) {
  final ListBuilder<Homework> items = ListBuilder(
    getList(data["items"])!.map<Homework>(
      (dynamic m) => tryParse(getMap(m)!, _parseHomework),
    ),
  );
  if (deduplicate) {
    for (var i = 0; i < items.length; i++) {
      final item = items[i];
      for (var ii = i + 1; ii < items.length;) {
        if (items[ii].serverEquals(item)) {
          items.removeAt(ii);
        } else {
          ii++;
        }
      }
    }
  }

  return Day((b) => b
    ..date = UtcDateTime.parse(getString(data["date"])!)
    ..homework = items);
}

Homework _parseHomework(Map data) {
  return Homework((b) {
    b
      ..id = getInt(data["id"])
      ..title = getString(data["title"])
      ..subtitle = getString(data["subtitle"])
      ..label = getString(data["label"])
      ..warning = data["homework"] == 0
      ..checkable = getBool(data["checkable"]) ?? b.checkable
      ..checked = getBool(data["checked"]) ?? false
      ..deleteable = getBool(data["deleteable"]) ?? b.deleteable
      ..gradeGroupSubmissions = data["gradeGroupSubmissions"] == null
          ? null
          : ListBuilder(getList(data["gradeGroupSubmissions"])!
              .map((dynamic s) =>
                  tryParse(getMap(s)!, _parseGradeGroupSubmission))
              .where((s) => s != null));

    final typeString = getString(data["type"]);
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
    b.type = type;

    if (type == HomeworkType.grade) {
      b
        ..gradeFormatted = formatGradeFromString(getString(data["grade"]))
        ..grade = getString(data["grade"]);
    }
  });
}

GradeGroupSubmission? _parseGradeGroupSubmission(Map data) {
  try {
    return GradeGroupSubmission(
      (b) => b
        ..file = getString(data["file"])
        ..originalName = getString(data["originalName"])
        ..timestamp = UtcDateTime.parse(getString(data["timestamp"])!)
        ..typeName = getString(data["typeName"])
        ..id = getInt(data["id"])
        ..gradeGroupId = getInt(data["gradeGroupId"])
        ..userId = getInt(data["userId"]),
    );
  } catch (e, s) {
    log("Failed to parse GradeGroupSubmission", error: e, stackTrace: s);
    // TODO: figure out a way to notify the user about this failure.
    return null;
  }
}

void _notLoaded(
    DashboardState state, Action<void> action, DashboardStateBuilder builder) {
  builder.loading = false;
}

void _loading(
    DashboardState state, Action<bool> action, DashboardStateBuilder builder) {
  builder.loading = true;
}

void _switchFuture(
    DashboardState state, Action<void> action, DashboardStateBuilder builder) {
  builder.future = !state.future;
}

void _homeworkAdded(DashboardState state, Action<HomeworkAddedPayload> action,
    DashboardStateBuilder builder) {
  builder.allDays.map(
    (day) => day.date == action.payload.date
        ? day.rebuild(
            (b) => b
              ..homework.add(
                _parseHomework(getMap(action.payload.data)!).rebuild(
                  (b) => b
                    ..firstSeen = now
                    ..lastNotSeen = now,
                ),
              ),
          )
        : day,
  );
}

void _homeworkRemoved(DashboardState state, Action<Homework> action,
    DashboardStateBuilder builder) {
  builder.allDays
      .map((day) => day.rebuild((b) => b..homework.remove(action.payload)));
}

void _toggleDone(DashboardState state, Action<ToggleDonePayload> action,
    DashboardStateBuilder builder) {
  builder.allDays.map((day) {
    final index =
        day.homework.indexWhere((hw) => hw.id == action.payload.homeworkId);
    if (index == -1) {
      return day;
    }
    return day.rebuild(
      (b) => b
        ..homework[index] = b.homework[index]
            .rebuild((hb) => hb..checked = action.payload.done),
    );
  });
}

void _markAsSeen(DashboardState state, Action<Homework> action,
    DashboardStateBuilder builder) {
  builder.allDays.map(
    (day) => day.homework.contains(action.payload)
        ? day.rebuild(
            (b) => b
              ..homework[day.homework.indexOf(action.payload)] =
                  action.payload.rebuild(
                (hb) => hb
                  ..isChanged = false
                  ..isNew = false,
              ),
          )
        : day,
  );
}

void _markDeletedHomeworkAsSeen(
    DashboardState state, Action<Day> action, DashboardStateBuilder builder) {
  builder.allDays.map((day) => day == action.payload
      ? day.rebuild(
          (b) => b
            ..deletedHomework.map(
              (h) => h.rebuild((b) => b..isChanged = false),
            ),
        )
      : day);
}

void _markAllAsSeen(
    DashboardState state, Action<void> action, DashboardStateBuilder builder) {
  builder.allDays.map(
    (day) => day.rebuild(
      (b) => b
        ..homework.map(
          (homework) => homework.rebuild((b) => b
            ..isChanged = false
            ..isNew = false),
        )
        ..deletedHomework.map(
          (homework) => homework.rebuild((b) => b..isChanged = false),
        ),
    ),
  );
}

void _updateBlacklist(DashboardState state,
    Action<BuiltList<HomeworkType>> action, DashboardStateBuilder builder) {
  builder.blacklist.replace(action.payload);
}

void _downloadAttachment(DashboardState state,
    Action<GradeGroupSubmission> action, DashboardStateBuilder builder) {
  builder.allDays.map(
    (day) => day.rebuild(
      (b) => b.homework.map(
        (hw) => hw.rebuild(
          (b) => b.gradeGroupSubmissions.map(
            (s) => s == action.payload
                ? s.rebuild((b) => b..downloading = true)
                : s,
          ),
        ),
      ),
    ),
  );
}

void _attachmentReady(DashboardState state, Action<GradeGroupSubmission> action,
    DashboardStateBuilder builder) {
  builder.allDays.map(
    (day) => day.rebuild(
      (b) => b.homework.map(
        (hw) => hw.rebuild(
          (b) => b.gradeGroupSubmissions.map(
            (s) => s.file == action.payload.file
                ? s.rebuild(
                    (b) => b
                      ..fileAvailable = action.payload.fileAvailable
                      ..downloading = false,
                  )
                : s,
          ),
        ),
      ),
    ),
  );
}
