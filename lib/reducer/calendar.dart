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

import 'package:built_collection/built_collection.dart';
import 'package:built_redux/built_redux.dart';

import 'package:dr/actions/calendar_actions.dart';
import 'package:dr/app_state.dart';
import 'package:dr/data.dart';
import 'package:dr/utc_date_time.dart';
import 'package:dr/util.dart';

final calendarReducerBuilder = NestedReducerBuilder<AppState, AppStateBuilder,
    CalendarState, CalendarStateBuilder>(
  (s) => s.calendarState,
  (b) => b.calendarState,
)
  ..add(CalendarActionsNames.loaded, _loaded)
  ..add(CalendarActionsNames.setCurrentMonday, _currentMonday)
  ..add(CalendarActionsNames.select, _selectedDay);

void _loaded(CalendarState state, Action<Map<String, dynamic>> action,
    CalendarStateBuilder builder) {
  final t = action.payload.map((k, dynamic e) {
    final date = UtcDateTime.parse(k);
    return MapEntry(
        date,
        tryParse<CalendarDayBuilder, dynamic>(
            e, (dynamic e) => _parseCalendarDay(getMap(e)!, date)).build());
  });
  builder.days.addAll(t);
}

void _currentMonday(CalendarState state, Action<UtcDateTime> action,
    CalendarStateBuilder builder) {
  builder.currentMonday = action.payload;
}

void _selectedDay(CalendarState state, Action<CalendarSelection?> action,
    CalendarStateBuilder builder) {
  builder.selection = action.payload?.toBuilder();
}

CalendarDayBuilder _parseCalendarDay(Map day, UtcDateTime date) {
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
    return _parseCalendarDay(getMap(day.values.single)!, date);
  }
  return CalendarDayBuilder()
    ..lastFetched = UtcDateTime.now()
    ..date = date
    ..hours = ListBuilder(
      (day.values.toList()
            ..removeWhere((dynamic e) => e == null || e["isLesson"] == 0)
            ..sort(
              (dynamic a, dynamic b) => getInt(a["hour"])!.compareTo(
                getInt(b["hour"])!,
              ),
            ))
          .map<CalendarHour>(
        (dynamic h) => tryParse(getMap(h)!, _parseHour).build(),
      ),
    );
}

CalendarHourBuilder _parseHour(Map hour) {
  final lesson = getMap(hour["lesson"])!;
  final timeSpans = ListBuilder<TimeSpan>();
  for (final linkedLesson in <dynamic>[
    lesson,
    ...getList(lesson["linkedHours"]) ?? <dynamic>[],
  ]) {
    final date = tryParse(
      getString(linkedLesson["date"])!,
      (String s) => UtcDateTime.parse(s),
    );
    UtcDateTime parseTime(UtcDateTime date, Map timeObject) {
      final h = getInt(timeObject["h"])!;
      final m = getInt(timeObject["m"])!;
      return UtcDateTime(date.year, date.month, date.day, h, m);
    }

    final from = parseTime(date, getMap(linkedLesson["timeStartObject"])!);
    final to = parseTime(date, getMap(linkedLesson["timeEndObject"])!);

    timeSpans.add(
      TimeSpan(
        (b) => b
          ..from = from
          ..to = to,
      ),
    );
  }
  return CalendarHourBuilder()
    ..fromHour = getInt(lesson["hour"])
    ..toHour = getInt(lesson["toHour"])
    ..timeSpans = timeSpans
    ..rooms = ListBuilder(
      getList(lesson["rooms"])!.map<String>((dynamic r) => r["name"] as String),
    )
    ..subject = getString(lesson["subject"]["name"])
    ..teachers = ListBuilder(
      getList(lesson["teachers"])!.map<Teacher>(
        (dynamic r) => Teacher((b) => b
          ..firstName = getString(r["firstName"])
          ..lastName = getString(r["lastName"])),
      ),
    )
    ..homeworkExams = ListBuilder(
      (lesson["homeworkExams"] as List).map<HomeworkExam>(
          (dynamic e) => tryParse(getMap(e)!, _parseHomeworkExam)),
    )
    ..lessonContents = ListBuilder(
      (lesson["lessonContents"] as List).map<LessonContent>(
          (dynamic e) => tryParse(getMap(e)!, _parseLessonContent)),
    );
}

HomeworkExam _parseHomeworkExam(Map homeworkExam) {
  return HomeworkExam((b) => b
    ..deadline = UtcDateTime.parse(getString(homeworkExam["deadline"])!)
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

LessonContent _parseLessonContent(Map lessonContent) {
  return LessonContent(
    (b) => b
      ..name = getString(lessonContent["name"])
      ..typeName = getString(lessonContent["typeName"]),
  );
}
