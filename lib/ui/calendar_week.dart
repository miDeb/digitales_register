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
import 'package:dr/app_state.dart';
import 'package:dr/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../container/calendar_week_container.dart';
import '../data.dart';
import 'no_internet.dart';

const holidayIconSize = 65.0;

class CalendarWeek extends StatelessWidget {
  final CalendarWeekViewModel vm;

  const CalendarWeek({
    Key? key,
    required this.vm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final latestHour =
        vm.days.fold<int>(0, (a, b) => a < b.toHour ? b.toHour : a);
    return vm.days.isEmpty
        ? vm.noInternet
            ? const NoInternet()
            : const Center(
                child: CircularProgressIndicator(),
              )
        : Column(
            children: <Widget>[
              Expanded(
                child: Row(
                  children: vm.days
                      .map(
                        (d) => Expanded(
                          child: CalendarDayWidget(
                            calendarDay: d,
                            max: latestHour,
                            subjectNicks: vm.subjectNicks,
                            isSelected: vm.selection?.date == d.date,
                            selectedHour: vm.selection?.date == d.date
                                ? vm.selection?.hour
                                : null,
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          );
  }
}

class _HoursChunk extends StatelessWidget {
  final BuiltMap<String, String> subjectNicks;
  final List<CalendarHour> hours;
  final CalendarDay day;
  final int? selectedHour;
  final bool isSelected;
  const _HoursChunk({
    Key? key,
    required this.subjectNicks,
    required this.hours,
    required this.day,
    required this.selectedHour,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Card(
          shape: RoundedRectangleBorder(
            side: BorderSide(
                color: isSelected
                    ? Theme.of(context).colorScheme.secondary
                    : Colors.grey,
                width: 0),
            borderRadius: BorderRadius.circular(8),
          ),
          color: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          child: Container(),
        ),
        Card(
          color: Colors.transparent,
          elevation: 0,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: List.generate(
              hours.length * 2 - 1,
              (n) => n % 2 == 0
                  ? HourWidget(
                      hour: hours[n ~/ 2],
                      subjectNicks: subjectNicks,
                      day: day,
                      isSelected: selectedHour == hours[n ~/ 2].fromHour,
                    )
                  : const Divider(
                      height: 0,
                    ),
            ),
          ),
        ),
      ],
    );
  }
}

class CalendarDayWidget extends StatelessWidget {
  final int max;
  final CalendarDay calendarDay;
  final BuiltMap<String, String> subjectNicks;
  final bool isSelected;
  final int? selectedHour;

  const CalendarDayWidget({
    Key? key,
    required this.max,
    required this.calendarDay,
    required this.subjectNicks,
    required this.isSelected,
    required this.selectedHour,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final chunks = <List<CalendarHour>>[];
    for (final hour in calendarDay.hours) {
      if (chunks.isEmpty) {
        chunks.add([hour]);
      } else {
        final last = chunks.last;
        if (last.last.toHour + 1 < hour.fromHour) {
          chunks.add([hour]);
        } else {
          last.add(hour);
        }
      }
    }
    return Column(
      children: <Widget>[
        Text(DateFormat("E", "de").format(calendarDay.date)),
        Text(
          DateFormat("dd.MM", "de").format(calendarDay.date),
          style: DefaultTextStyle.of(context).style.copyWith(fontSize: 12),
        ),
        if (chunks.isNotEmpty) ...[
          for (var i = 0; i < chunks.length; i++) ...[
            Expanded(
              flex: chunks[i].first.fromHour -
                  (i == 0 ? 0 : chunks[i - 1].last.toHour) -
                  1,
              child: Container(),
            ),
            Expanded(
              flex: chunks[i].last.toHour - chunks[i].first.fromHour + 1,
              child: _HoursChunk(
                hours: chunks[i],
                subjectNicks: subjectNicks,
                day: calendarDay,
                selectedHour: selectedHour,
                isSelected: isSelected,
              ),
            )
          ],
          Expanded(
            flex: max - calendarDay.toHour,
            child: Container(),
          )
        ] else
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 32, bottom: 4),
                  child: SizedBox(
                    height: 75,
                    width: 75,
                    child: findHolidayIconForSeason(
                      calendarDay.date,
                      Theme.of(context).iconTheme.color!,
                      holidayIconSize,
                    ),
                  ),
                ),
                Text(
                  "Frei",
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class HourWidget extends StatelessWidget {
  final CalendarHour hour;
  final CalendarDay day;
  final BuiltMap<String, String> subjectNicks;
  final bool isSelected;
  const HourWidget({
    Key? key,
    required this.hour,
    required this.subjectNicks,
    required this.day,
    required this.isSelected,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: hour.lenght,
      child: ClipRect(
        child: InkWell(
          onTap: () {
            actions.calendarActions.select(
              CalendarSelection((b) => b
                ..date = day.date
                ..hour = hour.fromHour),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              border: hour.warning
                  ? const Border(
                      left: BorderSide(color: Colors.red, width: 5),
                    )
                  : null,
              color: isSelected
                  ? Theme.of(context).colorScheme.secondary.withAlpha(15)
                  : null,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    subjectNicks[hour.subject.toLowerCase()] ?? hour.subject,
                    maxLines: 1,
                    softWrap: false,
                  ),
                  if (hour.teachers.isNotEmpty)
                    const SizedBox(
                      height: 5,
                    ),
                  for (final teacher in hour.teachers)
                    Text(
                      teacher.lastName,
                      maxLines: 1,
                      softWrap: false,
                      style: DefaultTextStyle.of(context)
                          .style
                          .copyWith(fontSize: 11),
                    ),
                  if (hour.rooms.isNotEmpty)
                    const SizedBox(
                      height: 5,
                    ),
                  for (final room in hour.rooms)
                    Text(
                      room,
                      maxLines: 1,
                      softWrap: false,
                      style: DefaultTextStyle.of(context)
                          .style
                          .copyWith(fontSize: 11),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

bool _dateIsNear(DateTime date1, DateTime date2) {
  return date1.difference(date2).inDays.abs() <= 3;
}

Widget findHolidayIconForSeason(DateTime date, Color color, double size) {
  // Weekends
  if (date.weekday >= 6) {
    return Icon(
      Icons.weekend,
      color: color,
      size: size,
    );
  }
  final month = date.month;
  final day = date.day;
  // Summer
  if (month >= 6 && month <= 9) {
    return Icon(
      Icons.beach_access,
      size: size,
      color: color,
    );
  }
  // Christmas
  if (month == 12 && day >= 22 || month == 1 && day <= 10) {
    return Icon(
      Icons.ac_unit_rounded,
      size: size,
      color: color,
    );
  }
  // Halloween
  if (month == 10 && day >= 24 || month == 11 && day <= 8) {
    return SvgPicture.asset(
      "assets/halloween.svg",
      color: color,
      height: size,
      width: size,
    );
  }
  // Easter
  final easter = calculateEaster(date.year);
  if (_dateIsNear(date, easter)) {
    return SvgPicture.asset(
      "assets/easter.svg",
      color: color,
      height: size,
      width: size,
    );
  }
  // Carnival
  final carnival = easter.subtract(const Duration(days: 47));
  if (_dateIsNear(date, carnival)) {
    return SvgPicture.asset(
      "assets/carnival.svg",
      color: color,
      height: size,
      width: size,
    );
  }

  // Default
  return Icon(
    Icons.celebration,
    size: size,
    color: color,
  );
}

/// Calculate the date of easter
// https://en.wikipedia.org/wiki/Date_of_Easter#Meeus.27s_Julian_algorithm
DateTime calculateEaster(int year) {
  final a = year % 19;
  final b = year ~/ 100;
  final c = year % 100;
  final d = b ~/ 4;
  final e = b % 4;
  final g = (8 * b + 13) ~/ 25;
  final h = (19 * a + b - d - g + 15) % 30;
  final i = c ~/ 4;
  final k = c % 4;
  final l = (32 + 2 * e + 2 * i - h - k) % 7;
  final m = (a + 11 * h + 19 * l) ~/ 433;
  final n = (h + l - 7 * m + 90) ~/ 25;
  final p = (h + l - 7 * m + 33 * n + 19) % 32;
  return DateTime(year, n, p);
}
