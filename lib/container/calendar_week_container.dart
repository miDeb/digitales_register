import 'package:flutter/material.dart';
import 'package:flutter_built_redux/flutter_built_redux.dart';

import '../actions/app_actions.dart';
import '../app_state.dart';
import '../data.dart';
import '../ui/calendar_week.dart';

class CalendarWeekContainer extends StatelessWidget {
  final DateTime monday;

  const CalendarWeekContainer({Key key, this.monday}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StoreConnection<AppState, AppActions, CalendarWeekViewModel>(
      builder: (context, vm, actions) {
        return CalendarWeek(vm: vm, key: key);
      },
      connect: (state) {
        return CalendarWeekViewModel(state, monday);
      },
    );
  }
}

typedef DayCallback = void Function(DateTime day);

class CalendarWeekViewModel {
  final List<CalendarDay> days;
  final Map<String, String> subjectNicks;
  final bool noInternet;

  CalendarWeekViewModel(AppState state, DateTime monday)
      : days = state.calendarState.daysForWeek(monday),
        subjectNicks = state.settingsState.subjectNicks.toMap(),
        noInternet = state.noInternet;
}
