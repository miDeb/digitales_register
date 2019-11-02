import 'package:intl/intl.dart';
import 'package:redux/redux.dart';

import '../actions.dart';
import '../app_state.dart';
import '../wrapper.dart';

List<Middleware<AppState>> calendarMiddlewares(Wrapper wrapper) => [
      TypedMiddleware<AppState, LoadCalendarAction>(
        (store, action, next) => _load(store, action, next, wrapper),
      ),
    ];

void _load(Store store, LoadCalendarAction action, NextDispatcher next,
    Wrapper wrapper) async {
  next(action);
  final data = await wrapper.post("/api/calendar/student",
      {"startDate": DateFormat("yyyy-MM-dd").format(action.startDate)});

  if (data != null) {
    store.dispatch(CalendarLoadedAction(data));
  }
}
