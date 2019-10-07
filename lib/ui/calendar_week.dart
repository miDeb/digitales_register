import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../container/calendar_week_container.dart';
import '../data.dart';
import 'dialog.dart';

class CalendarWeek extends StatefulWidget {
  final CalendarWeekViewModel vm;

  const CalendarWeek({Key key, this.vm}) : super(key: key);

  @override
  _CalendarWeekState createState() => _CalendarWeekState();
}

class _CalendarWeekState extends State<CalendarWeek> {
  bool loading = false;
  @override
  void initState() {
    loading = widget.vm.days.isEmpty;
    super.initState();
  }

  @override
  void didUpdateWidget(CalendarWeek oldWidget) {
    if (widget.vm.days.isNotEmpty) {
      loading = false;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final max = widget.vm.days.fold(0, (a, b) => a < b.lenght ? b.lenght : a);
    return loading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Row(
            children: widget.vm.days
                .map(
                  (d) => Expanded(
                    child: CalendarDayWidget(
                      calendarDay: d,
                      max: max,
                      showDate: widget.vm.showDates,
                    ),
                  ),
                )
                .toList());
  }
}

class CalendarDayWidget extends StatelessWidget {
  final int max;
  final CalendarDay calendarDay;
  final bool showDate;

  const CalendarDayWidget({Key key, this.max, this.calendarDay, this.showDate})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(DateFormat("E", "de").format(calendarDay.date)),
        if (showDate) Text(DateFormat("dd.MM", "de").format(calendarDay.date)),
        calendarDay.lenght != 0
            ? Expanded(
                flex: calendarDay.lenght,
                child: Stack(
                  children: <Widget>[
                    Card(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.grey, width: 0),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Container(),
                      color: Colors.transparent,
                      elevation: 0,
                    ),
                    Card(
                      color: Colors.transparent,
                      elevation: 0,
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        children: List.generate(
                          calendarDay.hours.length * 2 - 1,
                          (n) => n % 2 == 0
                              ? HourWidget(hour: calendarDay.hours[n ~/ 2])
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
                child: Text("Frei"),
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
  final shortSubjectNames = const {
    "Deutsch": "DEU",
    "Mathematik": "MAT",
    "Latein": "LAT",
    "Religion": "REL",
    "Englisch": "ENG",
    "Naturwissenschaften": "NAT",
    "Geschichte": "GESCH",
    "Italienisch": "ITA",
    "Bewegung und Sport": "SPORT",
    "Recht und Wirtschaft": "RW",
  };
  final CalendarHour hour;
  HourWidget({Key key, this.hour}) : super(key: key);
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
                  hour.hasDescription
                      ? Text(hour.description)
                      : Text(
                          "(keine Beschreibung)",
                          style: TextStyle(
                              fontWeight: FontWeight.w100,
                              color: Colors.grey,
                              fontStyle: FontStyle.italic),
                        ),
                  hour.hasHomework
                      ? RichText(
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
                        )
                      : null,
                  hour.hasExam
                      ? RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Test/Schularbeit/Prüfung: ",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(text: hour.exam),
                            ],
                            style: DefaultTextStyle.of(context).style,
                          ),
                        )
                      : null,
                  hour.rooms.isNotEmpty
                      ? RichText(
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
                        )
                      : null,
                  hour.teachers.isNotEmpty
                      ? RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Lehrer: ",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                  text: formatList(hour.teachers.toList())),
                            ],
                            style: DefaultTextStyle.of(context).style,
                          ),
                        )
                      : null,
                ].where((it) => it != null).toList();
                return ListViewCapableAlertDialog(
                    title: Text(hour.subject),
                    content: ListView.separated(
                      itemCount: items.length,
                      shrinkWrap: true,
                      separatorBuilder: (_, __) => Divider(),
                      itemBuilder: (context, i) => items[i],
                    ));
              });
        },
        child: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  (shortSubjectNames[hour.subject] ?? hour.subject),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                for (final room in hour.rooms)
                  Text(
                    room,
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                    style: DefaultTextStyle.of(context)
                        .style
                        .copyWith(fontSize: 12),
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
    return teachers.sublist(0, teachers.length - 2).join(", ") +
        " und " +
        teachers.last;
  }
}
