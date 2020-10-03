import 'package:flutter/material.dart';
import 'package:flutter_built_redux/flutter_built_redux.dart';
import 'package:built_collection/built_collection.dart';

import '../actions/app_actions.dart';
import '../actions/dashboard_actions.dart';
import '../app_state.dart';
import '../data.dart';
import '../ui/days.dart';

class DaysContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnection<AppState, AppActions, DaysViewModel>(
      builder: (context, vm, actions) {
        return DaysWidget(
          vm: vm,
          onSwitchFuture: actions.dashboardActions.switchFuture,
          refresh: actions.dashboardActions.refresh,
          addReminderCallback: (day, msg) {
            actions.dashboardActions.addReminder(
              AddReminderPayload(
                (b) => b
                  ..msg = msg
                  ..date = day.date,
              ),
            );
          },
          removeReminderCallback: (hw, day) {
            actions.dashboardActions.deleteHomework(hw);
          },
          toggleDoneCallback: (hw, done) {
            actions.dashboardActions.toggleDone(
              ToggleDonePayload(
                (b) => b
                  ..hw = hw.toBuilder()
                  ..done = done,
              ),
            );
          },
          setDoNotAskWhenDeleteCallback: () {
            actions.settingsActions.askWhenDeleteReminder(false);
          },
          markAsSeenCallback: actions.dashboardActions.markAsSeen,
          markDeletedHomeworkAsSeenCallback:
              actions.dashboardActions.markDeletedHomeworkAsSeen,
          markAllAsSeenCallback: actions.dashboardActions.markAllAsSeen,
        );
      },
      connect: (state) {
        return DaysViewModel.from(state);
      },
    );
  }
}

typedef AddReminderCallback = void Function(Day day, String reminder);
typedef RemoveReminderCallback = void Function(Homework hw, Day day);
typedef ToggleDoneCallback = void Function(Homework hw, bool done);
typedef MarkAsNotNewOrChangedCallback = void Function(Homework hw);
typedef MarkDeletedHomeworkAsSeenCallback = void Function(Day day);

class DaysViewModel {
  final List<Day> days;
  final bool future;
  final bool askWhenDelete;
  final bool noInternet, loading;
  final bool showAddReminder;

  DaysViewModel.from(AppState state)
      : days = (() {
          final unorderedDays = state.dashboardState.allDays
                  ?.where((day) => day.future == state.dashboardState.future)
                  ?.map(
                    (day) => day.rebuild(
                      (b) => b
                        ..deletedHomework.where(
                          (hw) => !isBlacklisted(
                              hw, state.dashboardState.blacklist),
                        )
                        ..homework.where(
                          (hw) => !isBlacklisted(
                              hw, state.dashboardState.blacklist),
                        ),
                    ),
                  )
                  ?.toList() ??
              [];
          if (!state.dashboardState.future)
            return unorderedDays?.reversed?.toList();
          else
            return unorderedDays;
        })(),
        noInternet = state.noInternet,
        future = state.dashboardState.future,
        loading = state.dashboardState.loading || state.loginState.loading,
        askWhenDelete = state.settingsState.askWhenDelete,
        showAddReminder =
            !state.dashboardState.blacklist.contains(HomeworkType.homework);
}

// Map all (previously by the server used) homework types to the titles they
// would have been used with. Probably incomplete.
const typesToTitles = {
  HomeworkType.grade: ["Bewertung"],
  // TODO: What about "Prüfung" etc?
  HomeworkType.gradeGroup: ["Testarbeit", "Schularbeit"],
  HomeworkType.homework: ["Erinnerung"],
  HomeworkType.lessonHomework: ["Hausaufgabe"],
  HomeworkType.observation: ["Beobachtung"],
};

bool isBlacklisted(Homework homework, BuiltList<HomeworkType> blacklist) {
  return blacklist.any((blacklisted) {
    return typesToTitles[blacklisted].contains(homework.title);
  });
}
