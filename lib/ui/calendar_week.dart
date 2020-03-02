import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';

import '../container/calendar_week_container.dart';
import '../data.dart';
import 'dialog.dart';
import 'no_internet.dart';

class CalendarWeek extends StatelessWidget {
  final CalendarWeekViewModel vm;

  const CalendarWeek({Key key, this.vm}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final max = vm.days.fold(0, (a, b) => a < b.lenght ? b.lenght : a);
    return vm.days.isEmpty
        ? vm.noInternet
            ? NoInternet()
            : Center(
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
  final Map<String, String> subjectNicks;

  const CalendarDayWidget(
      {Key key, this.max, this.calendarDay, this.subjectNicks})
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
        calendarDay.lenght != 0
            ? Expanded(
                flex: calendarDay.lenght,
                child: Stack(
                  children: <Widget>[
                    Card(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.grey, width: 0),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Container(),
                      color: Colors.transparent,
                      elevation: 0,
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
                              : Divider(
                                  height: 0,
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
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
  final Map<String, String> subjectNicks;
  HourWidget({Key key, this.hour, this.subjectNicks}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: hour.lenght,
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (_) {
              final items = [
                if (hour.hasDescription) Text(hour.description),
                if (hour.hasHomework)
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Hausaufgabe: ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: hour.homework),
                      ],
                      style: DefaultTextStyle.of(context).style,
                    ),
                  ),
                if (hour.hasExam)
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Test: ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: hour.exam),
                      ],
                      style: DefaultTextStyle.of(context).style,
                    ),
                  ),
                if (hour.rooms.isNotEmpty)
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
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
                        TextSpan(
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
              return ListViewCapableAlertDialog(
                titlePadding: EdgeInsets.zero,
                title: Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 24,
                          right: 24,
                          top: 24,
                        ),
                        child: Text(hour.subject),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4, right: 4),
                      child: IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ],
                ),
                content: ListView.separated(
                  itemCount: items.length,
                  shrinkWrap: true,
                  separatorBuilder: (_, __) => Divider(),
                  itemBuilder: (context, i) => items[i],
                ),
              );
            },
          );
        },
        child: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  (subjectNicks.entries
                          .firstWhere(
                              (entry) => equalsIgnoreAsciiCase(
                                  entry.key, hour.subject),
                              orElse: () => null)
                          ?.value ??
                      hour.subject),
                  maxLines: 1,
                  softWrap: false,
                ),
                if (hour.teachers.isNotEmpty)
                  SizedBox(
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
                  SizedBox(
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
          decoration: hour.hasExam
              ? BoxDecoration(
                  border: Border(
                    left: BorderSide(color: Colors.red, width: 5),
                  ),
                )
              : null,
        ),
      ),
    );
  }

  String formatList(List<String> teachers) {
    if (teachers.length <= 2) return teachers.join(" und ");
    return teachers.sublist(0, teachers.length - 1).join(", ") +
        " und " +
        teachers.last;
  }
}
