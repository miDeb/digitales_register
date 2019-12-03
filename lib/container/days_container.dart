import 'package:dr/ui/days.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../actions.dart';
import '../app_state.dart';
import '../data.dart';

class DaysContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, DaysViewModel>(
      builder: (BuildContext context, DaysViewModel vm) {
        return DaysWidget(
          vm: vm,
        );
      },
      converter: (Store<AppState> store) {
        return DaysViewModel.from(store);
      },
    );
  }
}

typedef void AddReminderCallback(Day day, String reminder);
typedef void RemoveReminderCallback(Homework hw, Day day);
typedef void ToggleDoneCallback(Homework hw, bool done);
typedef void MarkAsNotNewOrChangedCallback(Homework hw);

class DaysViewModel {
  final List<Day> days;
  final VoidCallback onSwitchFuture;
  final bool future;
  final bool askWhenDelete;
  final AddReminderCallback addReminderCallback;
  final RemoveReminderCallback removeReminderCallback;
  final ToggleDoneCallback toggleDoneCallback;
  final VoidCallback setDoNotWhenDeleteCallback;
  final MarkAsNotNewOrChangedCallback markAsNotNewOrChangedCallback;
  final VoidCallback markAllAsNotNewOrChangedCallback;
  final bool noInternet, loading;
  final VoidCallback refresh, refreshNoInternet;

  DaysViewModel.from(Store<AppState> store)
      : days = store.state.dayState.allDays
                ?.where((day) => day.future == store.state.dayState.future)
                ?.map(
                  (day) => day.rebuild(
                    (b) => b
                      ..deletedHomework.where(
                        (hw) =>
                            !store.state.dayState.blacklist.contains(hw.label),
                      )
                      ..homework.where(
                        (hw) =>
                            !store.state.dayState.blacklist.contains(hw.label),
                      ),
                  ),
                )
                ?.toList() ??
            [],
        onSwitchFuture = (() => store.dispatch(SwitchFutureAction())),
        noInternet = store.state.noInternet,
        refresh = (() => store.dispatch(RefreshAction())),
        refreshNoInternet = (() => store.dispatch(RefreshNoInternetAction())),
        future = store.state.dayState.future,
        loading = store.state.dayState.loading,
        addReminderCallback =
            ((day, msg) => store.dispatch(AddReminderAction(msg, day.date))),
        removeReminderCallback =
            ((hw, day) => store.dispatch(DeleteHomeworkAction(hw, day.date))),
        toggleDoneCallback =
            ((hw, done) => store.dispatch(ToggleDoneAction(hw, done))),
        askWhenDelete = store.state.settingsState.askWhenDelete,
        setDoNotWhenDeleteCallback =
            (() => store.dispatch(SetAskWhenDeleteAction(false))),
        markAsNotNewOrChangedCallback = ((homework) =>
            store.dispatch(MarkAsNotNewOrChangedAction(homework))),
        markAllAsNotNewOrChangedCallback =
            (() => store.dispatch(MarkAllAsNotNewOrChangedAction()));
}
