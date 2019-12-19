import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:quiver_hashcode/hashcode.dart';
import 'package:redux/redux.dart';

import '../actions/calendar_actions.dart';
import '../actions/routing_actions.dart';
import '../actions/settings_actions.dart';
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

  @override
  operator ==(other) {
    return other is CalendarViewModel &&
        other.showEditNicksBar == showEditNicksBar &&
        other.first == first &&
        other.last == last &&
        other.currentMonday == currentMonday;
  }

  @override
  int get hashCode => hash4(showEditNicksBar, first, last, currentMonday);

  CalendarViewModel(Store<AppState> store)
      : showEditSubjectNicks =
            (() => store.dispatch(ShowEditCalendarSubjectNicksAction())),
        closeEditNicksBar = (() => store.dispatch(
            SetShowCalendarSubjectNicksBarAction((b) => b..show = false))),
        dayCallback = ((day) => store.dispatch(
              LoadCalendarAction(
                (b) => b..startDate = day,
              ),
            )),
        currentMondayCallback = ((day) => store.dispatch(
              SetCalendarCurrentMondayAction(
                (b) => b..monday = day,
              ),
            )),
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
