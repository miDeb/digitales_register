import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

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
  final DateTime currentMonday;
  final VoidCallback nextWeek, prevWeek;
  final DayCallback dayCallback, currentMondayChanged;

  @override
  operator ==(other) {
    return other is CalendarViewModel && other.currentMonday == currentMonday;
  }

  CalendarViewModel(Store<AppState> store)
      : currentMonday = store.state.calendarState.currentMonday,
        nextWeek = (() {
          store.dispatch(LoadNextWeekCalendarAction());
        }),
        prevWeek = (() {
          store.dispatch(LoadPrevWeekCalendarAction());
        }),
        dayCallback = ((day) {
          store.dispatch(LoadWeekOfDayCalendarAction(day));
        }),
        currentMondayChanged = ((day) {
          store.dispatch(CurrentMondayChangedAction(day));
        });
}
