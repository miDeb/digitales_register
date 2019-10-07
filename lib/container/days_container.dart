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
  DaysViewModel.from(Store<AppState> store)
      : days = store.state.dayState.displayDays.toList(),
        onSwitchFuture = (() => store.dispatch(SwitchFutureAction())),
        future = store.state.dayState.future,
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
