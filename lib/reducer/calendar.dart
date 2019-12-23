import 'package:built_collection/built_collection.dart';
import 'package:built_redux/built_redux.dart';

import '../actions/calendar_actions.dart';
import '../app_state.dart';
import '../data.dart';

final calendarReducerBuilder = NestedReducerBuilder<AppState, AppStateBuilder,
    CalendarState, CalendarStateBuilder>(
  (s) => s.calendarState,
  (b) => b.calendarState,
)
  ..add(CalendarActionsNames.loaded, _loaded)
  ..add(CalendarActionsNames.setCurrentMonday, _currentMonday);

void _loaded(
    CalendarState state, Action<Object> action, CalendarStateBuilder builder) {
  final t = (action.payload as Map).map((k, e) {
    final date = DateTime.parse(k);
    return MapEntry(date, _parseCalendarDay(e, date).build());
  });
  builder.days.addAll(t);
}

void _currentMonday(CalendarState state, Action<DateTime> action,
    CalendarStateBuilder builder) {
  builder..currentMonday = action.payload;
}

CalendarDayBuilder _parseCalendarDay(day, DateTime date) {
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
    return _parseCalendarDay((day as Map).values.single, date);
  return CalendarDayBuilder()
    ..date = date
    ..hours = ListBuilder(((day as Map).values.toList()
          ..removeWhere((e) => e == null || e["isLesson"] == 0)
          ..sort((a, b) => a["hour"].compareTo(b["hour"])))
        .map((h) => _parseHour(h).build()));
}

CalendarHourBuilder _parseHour(hour) {
  final lesson = hour["lesson"];
  return CalendarHourBuilder()
    ..description = lesson["description"]
    ..exam = lesson["exam"]["name"]
    ..fromHour = lesson["hour"]
    ..toHour = lesson["toHour"]
    ..homework = lesson["homework"]["name"] ?? ""
    ..rooms = ListBuilder((lesson["rooms"] as List).map((r) => r["name"]))
    ..subject = lesson["subject"]["name"]
    ..teachers = ListBuilder(
      (lesson["teachers"] as List).map(
        (r) => Teacher(
          (b) => b
            ..firstName = r["firstName"]
            ..lastName = r["lastName"],
        ),
      ),
    );
}
