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

import 'dart:math';

import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../container/calendar_week_container.dart';
import '../data.dart';
import 'dialog.dart';
import 'no_internet.dart';

class CalendarWeek extends StatelessWidget {
  final CalendarWeekViewModel vm;

  const CalendarWeek({Key? key, required this.vm}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final max = vm.days.fold<int>(0, (a, b) => a < b.lenght ? b.lenght : a);
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
                              max: max,
                              subjectNicks: vm.subjectNicks,
                            ),
                          ),
                        )
                        .toList()),
              ),
            ],
          );
  }
}

class CalendarDayWidget extends StatelessWidget {
  final int max;
  final CalendarDay calendarDay;
  final BuiltMap<String, String> subjectNicks;

  const CalendarDayWidget(
      {Key? key,
      required this.max,
      required this.calendarDay,
      required this.subjectNicks})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(DateFormat("E", "de").format(calendarDay.date)),
        Text(
          DateFormat("dd.MM", "de").format(calendarDay.date),
          style: DefaultTextStyle.of(context).style.copyWith(fontSize: 12),
        ),
        if (calendarDay.lenght != 0)
          Expanded(
            flex: calendarDay.lenght,
            child: Stack(
              children: <Widget>[
                Card(
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Colors.grey, width: 0),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  color: Colors.transparent,
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
                      calendarDay.hours.length * 2 - 1,
                      (n) => n % 2 == 0
                          ? HourWidget(
                              hour: calendarDay.hours[n ~/ 2],
                              subjectNicks: subjectNicks,
                            )
                          : const Divider(
                              height: 0,
                            ),
                    ),
                  ),
                ),
              ],
            ),
          )
        else
          const Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Text("Frei"),
            ),
          ),
        Expanded(
          flex: max - calendarDay.lenght,
          child: Container(),
        )
      ],
    );
  }
}

class HourWidget extends StatelessWidget {
  final CalendarHour hour;
  final BuiltMap<String, String> subjectNicks;
  const HourWidget({Key? key, required this.hour, required this.subjectNicks})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: hour.lenght,
      child: ClipRect(
        child: InkWell(
          onTap: () {
            showDialog<void>(
              context: context,
              builder: (_) {
                final items = [
                  if (hour.hasDescription) Text(hour.description!),
                  for (final lessonContent in hour.lessonContents)
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "${lessonContent.typeName}: ",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: lessonContent.name),
                        ],
                        style: DefaultTextStyle.of(context).style,
                      ),
                    ),
                  for (HomeworkExam homeworkExam in hour.homeworkExams)
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "${homeworkExam.typeName}: ",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: homeworkExam.name),
                        ],
                        style: DefaultTextStyle.of(context).style,
                      ),
                    ),
                  if (hour.rooms.isNotEmpty)
                    RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: "Räume: ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: formatList(hour.rooms.toList())),
                        ],
                        style: DefaultTextStyle.of(context).style,
                      ),
                    ),
                  if (hour.teachers.isNotEmpty)
                    RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: "Lehrer: ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                              text: formatList(hour.teachers
                                  .map((t) => "${t.firstName} ${t.lastName}")
                                  .toList())),
                        ],
                        style: DefaultTextStyle.of(context).style,
                      ),
                    ),
                ];
                return InfoDialog(
                    title: Text(hour.subject),
                    content: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(
                          max(items.length * 2 - 1, 0),
                          (index) => index.isEven
                              ? items[index ~/ 2]
                              : const Divider(),
                        ),
                      ),
                    ));
              },
            );
          },
          child: Container(
            decoration: hour.warning
                ? const BoxDecoration(
                    border: Border(
                      left: BorderSide(color: Colors.red, width: 5),
                    ),
                  )
                : null,
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

  String formatList(List<String> teachers) {
    if (teachers.length <= 2) return teachers.join(" und ");
    return "${teachers.sublist(0, teachers.length - 1).join(", ")} und ${teachers.last}";
  }
}
