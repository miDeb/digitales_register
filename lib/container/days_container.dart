import 'package:flutter/material.dart';
import 'package:flutter_built_redux/flutter_built_redux.dart';

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

typedef void AddReminderCallback(Day day, String reminder);
typedef void RemoveReminderCallback(Homework hw, Day day);
typedef void ToggleDoneCallback(Homework hw, bool done);
typedef void MarkAsNotNewOrChangedCallback(Homework hw);
typedef void MarkDeletedHomeworkAsSeenCallback(Day day);

class DaysViewModel {
  final List<Day> days;
  final bool future;
  final bool askWhenDelete;
  final bool noInternet, loading;

  DaysViewModel.from(AppState state)
      : days = (() {
          final unorderedDays = state.dashboardState.allDays
                  ?.where((day) => day.future == state.dashboardState.future)
                  ?.map(
                    (day) => day.rebuild(
                      (b) => b
                        ..deletedHomework.where(
                          (hw) =>
                              !state.dashboardState.blacklist.contains(hw.type),
                        )
                        ..homework.where(
                          (hw) =>
                              !state.dashboardState.blacklist.contains(hw.type),
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
        askWhenDelete = state.settingsState.askWhenDelete;
}
