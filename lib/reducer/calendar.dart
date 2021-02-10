import 'package:built_collection/built_collection.dart';
import 'package:built_redux/built_redux.dart';

import '../actions/calendar_actions.dart';
import '../app_state.dart';
import '../data.dart';
import '../util.dart';

final calendarReducerBuilder = NestedReducerBuilder<AppState, AppStateBuilder,
    CalendarState, CalendarStateBuilder>(
  (s) => s.calendarState,
  (b) => b.calendarState,
)
  ..add(CalendarActionsNames.loaded, _loaded)
  ..add(CalendarActionsNames.setCurrentMonday, _currentMonday);

void _loaded(CalendarState state, Action<Map<String, dynamic>> action,
    CalendarStateBuilder builder) {
  final t = action.payload.map((k, e) {
    final date = DateTime.parse(k);
    return MapEntry(
        date, tryParse(e, (e) => _parseCalendarDay(getMap(e), date)).build());
  });
  builder.days.addAll(t);
}

void _currentMonday(CalendarState state, Action<DateTime> action,
    CalendarStateBuilder builder) {
  builder.currentMonday = action.payload;
}

CalendarDayBuilder _parseCalendarDay(Map day, DateTime date) {
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
  if (day.length == 1) {
    return _parseCalendarDay(getMap(day.values.single), date);
  }
  return CalendarDayBuilder()
    ..date = date
    ..hours = ListBuilder((day.values.toList()
          ..removeWhere((e) => e == null || e["isLesson"] == 0)
          ..sort((a, b) => getInt(a["hour"]).compareTo(getInt(b["hour"]))))
        .map((h) => tryParse(getMap(h), _parseHour).build()));
}

CalendarHourBuilder _parseHour(Map hour) {
  final lesson = getMap(hour["lesson"]);
  return CalendarHourBuilder()
    ..description = getString(lesson["description"])
    ..fromHour = getInt(lesson["hour"])
    ..toHour = getInt(lesson["toHour"])
    ..rooms = ListBuilder(getList(lesson["rooms"]).map((r) => r["name"]))
    ..subject = getString(lesson["subject"]["name"])
    ..teachers = ListBuilder(
      getList(lesson["teachers"]).map(
        (r) => Teacher((b) => b
          ..firstName = getString(r["firstName"])
          ..lastName = getString(r["lastName"])),
      ),
    )
    ..homeworkExams = ListBuilder(
      (lesson["homeworkExams"] as List)
          .map((e) => tryParse(getMap(e), _parseHomeworkExam)),
    );
}

HomeworkExam _parseHomeworkExam(Map homeworkExam) {
  return HomeworkExam((b) => b
    ..deadline = DateTime.parse(getString(homeworkExam["deadline"]))
    ..hasGradeGroupSubmissions =
        getBool(homeworkExam["hasGradeGroupSubmissions"])
    ..hasGrades = getBool(homeworkExam["hasGrades"])
    ..homework = homeworkExam["homework"] != 0
    ..id = getInt(homeworkExam["id"])
    ..name = getString(homeworkExam["name"])
    ..online = homeworkExam["online"] != 0
    ..typeId = getInt(homeworkExam["typeId"])
    ..typeName = getString(homeworkExam["typeName"]));
}
