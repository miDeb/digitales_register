import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../container/calendar_week_container.dart';
import '../data.dart';

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
                        ),
                      ),
                )
                .toList());
  }
}

class CalendarDayWidget extends StatelessWidget {
  final int max;
  final CalendarDay calendarDay;

  const CalendarDayWidget({Key key, this.max, this.calendarDay})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(DateFormat("E", "de").format(calendarDay.date)),
        calendarDay.lenght != 0
            ? Expanded(
                flex: calendarDay.lenght,
                child: Card(
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
                return AlertDialog(
                    title: Text(hour.subject),
                    contentPadding: EdgeInsets.all(16.0),
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
            child: Text(
              shortSubjectNames[hour.subject] ?? hour.subject,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
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
