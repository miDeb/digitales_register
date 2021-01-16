import 'package:built_collection/built_collection.dart';
import 'package:built_redux/built_redux.dart';

import '../actions/dashboard_actions.dart';
import '../app_state.dart';
import '../data.dart';
import '../util.dart';

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
  List<Day> loadedDays = List.from(
    (action.payload.data as List).map(
      (d) => _parseDay(d, action.payload.deduplicateEntries),
    ),
  );

  List<Day> daysToDelete = [];

  builder.allDays.map(
    (day) => day.rebuild(
      (b) {
        final newDay = loadedDays.firstWhere(
          (d) => d.date == day.date,
          orElse: () => null,
        );
        if (newDay == null) {
          if (!action.payload.future &&
              day.date.isBefore(
                now.subtract(
                  Duration(days: 1),
                ), // subtract to not accidentally delete today
              )) {
            daysToDelete.add(day);
          }
          return;
        }
        loadedDays.remove(newDay);
        final newHomework = newDay.homework.toList();
        for (var oldHw in day.homework.toList()) {
          // look if there is any matching id first
          final newHw = newHomework.firstWhere(
            (d) => d.id == oldHw.id,
            // then look for other similarities
            orElse: () => newHomework.firstWhere(
              (d) => d.isSuccessorOf(oldHw),
              orElse: () => null,
            ),
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
                  ..firstSeen = now),
              );
            }
          } else if (!newHw.serverEquals(oldHw)) {
            b.homework.remove(oldHw);
            b.homework.add(newHw.rebuild((b) => b
              ..previousVersion = oldHw.toBuilder()
              ..lastNotSeen = day.lastRequested
              ..firstSeen = now
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
            mergedHw.gradeGroupSubmissions?.map(
              (ggs) => ggs.rebuild(
                (ggs) => ggs.fileAvailable = oldHw.gradeGroupSubmissions.any(
                  (oldGgs) => oldGgs.file == ggs.file,
                ),
              ),
            );
            b.homework[b.homework.build().indexOf(oldHw)] = mergedHw.build();
          }
          newHomework.remove(newHw);
        }
        for (var newHw in newHomework) {
          final deletedHw = day.deletedHomework.firstWhere(
            (d) => d.id == newHw.id,
            orElse: () => day.deletedHomework.firstWhere(
              (d) => d.isSuccessorOf(newHw),
              orElse: () => null,
            ),
          );
          if (deletedHw != null) {
            b.deletedHomework.remove(deletedHw);
            b.homework.add(newHw.rebuild((b) => b
              ..previousVersion = deletedHw.toBuilder()
              ..lastNotSeen = day.lastRequested
              ..firstSeen = now
              ..isChanged = action.payload.markNewOrChangedEntries));
          } else {
            b.homework.add(newHw.rebuild((b) => b
              ..lastNotSeen = day.lastRequested
              ..firstSeen = now
              ..isNew = newHw.type != HomeworkType.grade &&
                  newHw.type != HomeworkType.homework &&
                  action.payload.markNewOrChangedEntries));
          }
        }
        b.lastRequested = now;
      },
    ),
  );
  builder.allDays.removeWhere((day) => daysToDelete.contains(day));

  for (var newDay in loadedDays) {
    builder.allDays.add(newDay.rebuild((b) => b
      ..lastRequested = now
      ..homework.map((h) => h.rebuild((b) => b..firstSeen = now))));
  }
  builder.allDays.sort((a, b) => a.date.compareTo(b.date));
  builder..loading = false;
}

Day _parseDay(data, bool deduplicate) {
  final ListBuilder<Homework> items =
      ListBuilder(data["items"].map((m) => _parseHomework(m)));
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
    ..date = DateTime.parse(data["date"])
    ..homework = items);
}

Homework _parseHomework(data) {
  return Homework((b) {
    b
      ..id = data["id"]
      ..title = data["title"]
      ..subtitle = data["subtitle"]
      ..label = data["label"]
      ..warningServerSaid = data["warning"] ?? b.warningServerSaid
      ..checkable = data["checkable"] ?? b.checkable
      ..checked = data["checked"] is bool
          ? data["checked"]
          : (data["checked"] ?? 0) != 0
      ..deleteable = data["deleteable"] ?? b.deleteable
      ..gradeGroupSubmissions = data["gradeGroupSubmissions"] == null
          ? null
          : ListBuilder(data["gradeGroupSubmissions"]
              .map((s) => _parseGradeGroupSubmission(s)));

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

GradeGroupSubmission _parseGradeGroupSubmission(data) {
  return GradeGroupSubmission(
    (b) => b
      ..file = data["file"]
      ..originalName = data["originalName"]
      ..timestamp = DateTime.parse(data["timestamp"])
      ..typeName = data["typeName"]
      ..id = data["id"]
      ..gradeGroupId = data["gradeGroupId"]
      ..userId = data["userId"],
  );
}

void _notLoaded(
    DashboardState state, Action<void> action, DashboardStateBuilder builder) {
  builder..loading = false;
}

void _loading(
    DashboardState state, Action<bool> action, DashboardStateBuilder builder) {
  builder..loading = true;
}

void _switchFuture(
    DashboardState state, Action<void> action, DashboardStateBuilder builder) {
  builder..future = !state.future;
}

void _homeworkAdded(DashboardState state, Action<HomeworkAddedPayload> action,
    DashboardStateBuilder builder) {
  builder
    ..allDays.map(
      (day) => day.date == action.payload.date
          ? day.rebuild(
              (b) => b..homework.add(_parseHomework(action.payload.data)))
          : day,
    );
}

void _homeworkRemoved(DashboardState state, Action<Homework> action,
    DashboardStateBuilder builder) {
  builder
    ..allDays
        .map((day) => day.rebuild((b) => b..homework.remove(action.payload)));
}

void _toggleDone(DashboardState state, Action<ToggleDonePayload> action,
    DashboardStateBuilder builder) {
  builder
    ..allDays.map((day) => day.homework.contains(action.payload.hw)
        ? day.rebuild((b) => b
          ..homework[day.homework.indexOf(action.payload.hw)] = action
              .payload.hw
              .rebuild((hb) => hb..checked = action.payload.done))
        : day);
}

void _markAsSeen(DashboardState state, Action<Homework> action,
    DashboardStateBuilder builder) {
  builder
    ..allDays.map(
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
  builder
    ..allDays.map((day) => day == action.payload
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
  builder
    ..allDays.map(
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
  builder..blacklist.replace(action.payload);
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
                      ..fileAvailable = true
                      ..downloading = false,
                  )
                : s,
          ),
        ),
      ),
    ),
  );
}
