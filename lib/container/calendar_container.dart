import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:collection/collection.dart';

import '../actions.dart';
import '../app_state.dart';
import '../ui/calendar.dart';

class CalendarContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CalendarViewModel>(
      builder: (BuildContext context, CalendarViewModel vm) {
        return Calendar(
          vm: vm,
        );
      },
      distinct: true,
      converter: (Store<AppState> store) {
        return CalendarViewModel(store);
      },
    );
  }
}

typedef void DayCallback(DateTime day);

class CalendarViewModel {
  final DayCallback dayCallback;
  final DayCallback currentMondayCallback;
  final VoidCallback showEditSubjectNicks;
  final VoidCallback closeEditNicksBar;
  final bool showEditNicksBar;
  final DateTime first;
  final DateTime last;
  final DateTime currentMonday;

  CalendarViewModel(Store<AppState> store)
      : showEditSubjectNicks =
            (() => store.dispatch(ShowEditCalendarSubjectNicksAction())),
        closeEditNicksBar =
            (() => store.dispatch(SetShowCalendarSubjectNicksBarAction(false))),
        dayCallback = ((day) => store.dispatch(LoadCalendarAction(day))),
        currentMondayCallback =
            ((day) => store.dispatch(SetCalendarCurrentMondayAction(day))),
        first = store.state.calendarState.currentDays.isEmpty
            ? null
            : store.state.calendarState.currentDays.first.date,
        last = store.state.calendarState.currentDays.isEmpty
            ? null
            : store.state.calendarState.currentDays.last.date,
        currentMonday = store.state.calendarState.currentMonday,
        showEditNicksBar = store.state.calendarState.currentDays.any(
              (day) => day.hours.any(
                (hour) => store.state.settingsState.subjectNicks.entries.every(
                  (entry) => !equalsIgnoreAsciiCase(entry.key, hour.subject),
                ),
              ),
            ) &&
            store.state.settingsState.showCalendarNicksBar;
}
