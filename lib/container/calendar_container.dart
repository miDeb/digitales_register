import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_built_redux/flutter_built_redux.dart';

import '../actions/app_actions.dart';
import '../app_state.dart';
import '../ui/calendar.dart';

class CalendarContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnection<AppState, AppActions, CalendarViewModel>(
      builder: (context, vm, actions) {
        return Calendar(
          vm: vm,
          showEditSubjectNicks: actions.routingActions.showEditCalendarSubjectNicks,
          closeEditNicksBar: () => actions.settingsActions.showCalendarSubjectNicksBar(false),
          dayCallback: actions.calendarActions.load,
          currentMondayCallback: actions.calendarActions.setCurrentMonday,
        );
      },
      connect: (state) {
        return CalendarViewModel(state);
      },
    );
  }
}

typedef void DayCallback(DateTime day);

class CalendarViewModel {
  final bool showEditNicksBar, noInternet;
  final DateTime first;
  final DateTime last;
  final DateTime currentMonday;

  CalendarViewModel(AppState state)
      : first = state.calendarState.currentDays.isEmpty
            ? null
            : state.calendarState.currentDays.first.date,
        last = state.calendarState.currentDays.isEmpty
            ? null
            : state.calendarState.currentDays.last.date,
        currentMonday = state.calendarState.currentMonday,
        showEditNicksBar = state.calendarState.currentDays.any(
              (day) => day.hours.any(
                (hour) => state.settingsState.subjectNicks.entries.every(
                  (entry) => !equalsIgnoreAsciiCase(entry.key, hour.subject),
                ),
              ),
            ) &&
            state.settingsState.showCalendarNicksBar,
        noInternet = state.noInternet;
}
