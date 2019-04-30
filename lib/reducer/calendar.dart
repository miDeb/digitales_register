import 'package:built_collection/built_collection.dart';
import 'package:redux/redux.dart';

import '../actions.dart';
import '../app_state.dart';
import '../data.dart';

final calendarReducer = combineReducers<CalendarStateBuilder>([
  _calendarLoadedReducer.call,
  _calendarDaySetReducer.call,
]);

final _calendarLoadedReducer =
    TypedReducer<CalendarStateBuilder, CalendarLoadedAction>(
        (CalendarStateBuilder state, CalendarLoadedAction action) {
  final t = (action.result as Map).map((k, e) {
    final date = DateTime.parse(k);
    return MapEntry(date, parseCalendarDay(e, date).build());
  });
  return state..days.addAll(t);
});

final _calendarDaySetReducer =
    TypedReducer<CalendarStateBuilder, CurrentMondayChangedAction>(
        (state, action) {
  return state..currentMonday = action.monday;
});

CalendarDayBuilder parseCalendarDay(day, DateTime date) {
  return CalendarDayBuilder()
    ..date = date
    ..hours = ListBuilder(((day as Map).values.toList()
          ..removeWhere((e) => e == null)
          ..sort((a, b) => a["hour"].compareTo(b["hour"])))
        .map((h) => parseHour(h).build()));
}

CalendarHourBuilder parseHour(hour) {
  return CalendarHourBuilder()
    ..description = hour["description"]
    ..exam = hour["exam"]["name"]
    ..fromHour = hour["hour"]
    ..toHour = hour["toHour"]
    ..homework = hour["homework"]["name"] ?? ""
    ..rooms = ListBuilder((hour["rooms"] as List).map((r) => r["name"]))
    ..subject = hour["subject"]["name"]
    ..teachers = ListBuilder((hour["teachers"] as List)
        .map((r) => "${r["firstName"]} ${r["lastName"]}"));
}
