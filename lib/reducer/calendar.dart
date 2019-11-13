import 'package:built_collection/built_collection.dart';
import 'package:redux/redux.dart';

import '../actions.dart';
import '../app_state.dart';
import '../data.dart';

Reducer<CalendarStateBuilder> calendarReducer =
    (CalendarStateBuilder state, action) {
  return state
    ..days = TypedReducer(_calendarLoadedReducer)(state.days, action)
    ..currentMonday =
        TypedReducer(_currentMondayReducer)(state.currentMonday, action);
};

MapBuilder<DateTime, CalendarDay> _calendarLoadedReducer(
    MapBuilder<DateTime, CalendarDay> state, CalendarLoadedAction action) {
  final t = (action.result as Map).map((k, e) {
    final date = DateTime.parse(k);
    return MapEntry(date, parseCalendarDay(e, date).build());
  });
  return state..addAll(t);
}

DateTime _currentMondayReducer(
    DateTime currentMonday, SetCalendarCurrentMondayAction action) {
  return action.monday;
}

CalendarDayBuilder parseCalendarDay(day, DateTime date) {
  // needed because JSON now looks like:
  // "2019-11-04": {
  //    "1": {
  //      "1": {
  //        "1": {
  //           // actual data
  //        },
  //        "2"...
  //      },
  //    },
  // }
  if ((day as Map).length == 1)
    return parseCalendarDay((day as Map).values.single, date);
  return CalendarDayBuilder()
    ..date = date
    ..hours = ListBuilder(((day as Map).values.toList()
          ..removeWhere((e) => e == null || e["isLesson"] == 0)
          ..sort((a, b) => a["hour"].compareTo(b["hour"])))
        .map((h) => parseHour(h).build()));
}

CalendarHourBuilder parseHour(hour) {
  final lesson = hour["lesson"];
  return CalendarHourBuilder()
    ..description = lesson["description"]
    ..exam = lesson["exam"]["name"]
    ..fromHour = lesson["hour"]
    ..toHour = lesson["toHour"]
    ..homework = lesson["homework"]["name"] ?? ""
    ..rooms = ListBuilder((lesson["rooms"] as List).map((r) => r["name"]))
    ..subject = lesson["subject"]["name"]
    ..teachers = ListBuilder((lesson["teachers"] as List)
        .map((r) => "${r["firstName"]} ${r["lastName"]}"));
}
