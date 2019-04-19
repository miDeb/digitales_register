import 'package:intl/intl.dart';
import 'package:redux/redux.dart';

import '../actions.dart';
import '../app_state.dart';
import '../util.dart';
import '../wrapper.dart';

List<Middleware<AppState>> calendarMiddlewares(Wrapper wrapper) => [
      _modify,
      TypedMiddleware<AppState, LoadCalendarAction>(
        (store, action, next) => _load(store, action, next, wrapper),
      ),
    ];

void _modify(Store<AppState> store, action, NextDispatcher next) {
  if (action is LoadNextWeekCalendarAction) {
    store.dispatch(
      LoadCalendarAction(
        store.state.calendarState.currentMonday.add(
          Duration(days: 7),
        ),
      ),
    );
  } else if (action is LoadPrevWeekCalendarAction) {
    store.dispatch(
      LoadCalendarAction(
        store.state.calendarState.currentMonday.subtract(
          Duration(days: 7),
        ),
      ),
    );
  } else if (action is LoadWeekOfDayCalendarAction) {
    store.dispatch(
      LoadCalendarAction(toMonday(action.weekDay)),
    );
  }
  next(action);
}

void _load(Store store, LoadCalendarAction action, NextDispatcher next,
    Wrapper wrapper) async {
  next(action);
  final data = await wrapper.post("api/calendar/student",
      {"startDate": DateFormat("yyyy-MM-dd").format(action.startDate)});

  if (data != null) {
    store.dispatch(CalendarLoadedAction(data));
  }
}
