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

part of 'middleware.dart';

final _calendarMiddleware =
    MiddlewareBuilder<AppState, AppStateBuilder, AppActions>()
      ..add(CalendarActionsNames.load, _loadCalendar)
      ..add(CalendarActionsNames.select, _selectionChanged)
      ..add(CalendarActionsNames.setCurrentMonday, _weekChanged)
      ..add(RoutingActionsNames.showCalendar, _clearSelection);

Future<void> _loadCalendar(
    MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next,
    Action<DateTime> action) async {
  if (api.state.noInternet) return;

  await next(action);
  final dynamic data = await wrapper.send("api/calendar/student",
      args: {"startDate": DateFormat("yyyy-MM-dd").format(action.payload)});

  if (data != null) {
    api.actions.calendarActions.loaded(data as Map<String, dynamic>);
  } else {
    api.actions.refreshNoInternet();
  }
}

Future<void> _selectionChanged(
    MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next,
    Action<CalendarSelection?> action) async {
  await next(action);
  if (action.payload == null) {
    return;
  }
  final newWeek = toMonday(action.payload!.date);
  if (api.state.calendarState.currentMonday != newWeek) {
    api.actions.calendarActions.setCurrentMonday(newWeek);
    api.actions.calendarActions.load(newWeek);
  }
}

Future<void> _weekChanged(
    MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next,
    Action<DateTime> action) async {
  await next(action);
  final selectedDate = api.state.calendarState.selection?.date;
  if (selectedDate != null && toMonday(selectedDate) != action.payload) {
    api.actions.calendarActions.select(
      CalendarSelection(
        (b) => b
          ..date = DateTime(
            action.payload.year,
            action.payload.month,
            action.payload.day,
          ),
      ),
    );
  }
}

Future<void> _clearSelection(
    MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next,
    Action<void> action) async {
  await next(action);
  api.actions.calendarActions.select(null);
}
