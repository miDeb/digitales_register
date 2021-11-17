// Copyright (C) 2021 Michael Debertol
//
// This file is part of digitales_register.
//
// digitales_register is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// digitales_register is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with digitales_register.  If not, see <http://www.gnu.org/licenses/>.

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_built_redux/flutter_built_redux.dart';

import '../actions/app_actions.dart';
import '../app_state.dart';
import '../ui/calendar.dart';
import '../utc_date_time.dart';

class CalendarContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnection<AppState, AppActions, CalendarViewModel>(
      builder: (context, vm, actions) {
        return Calendar(
          vm: vm,
          showEditSubjectNicks:
              actions.routingActions.showEditCalendarSubjectNicks,
          closeEditNicksBar: () =>
              actions.settingsActions.showCalendarSubjectNicksBar(false),
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

typedef DayCallback = void Function(UtcDateTime day);

class CalendarViewModel {
  final bool showEditNicksBar, noInternet;
  final UtcDateTime? first;
  final UtcDateTime? last;
  final UtcDateTime currentMonday;
  final CalendarSelection? selection;

  CalendarViewModel(AppState state)
      : first = state.calendarState.currentDays.isEmpty
            ? null
            : state.calendarState.currentDays.first.date,
        last = state.calendarState.currentDays.isEmpty
            ? null
            : state.calendarState.currentDays.last.date,
        currentMonday = state.calendarState.currentMonday!,
        showEditNicksBar = state.calendarState.currentDays.any(
              (day) => day.hours.any(
                (hour) => state.settingsState.subjectNicks.entries.none(
                  (entry) => equalsIgnoreAsciiCase(entry.key, hour.subject),
                ),
              ),
            ) &&
            state.settingsState.showCalendarNicksBar,
        noInternet = state.noInternet,
        selection = state.calendarState.selection;
}
