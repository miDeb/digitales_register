import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../app_state.dart';
import '../container/grades_chart_container.dart';
import '../util.dart';

class GradesChart extends StatelessWidget {
  final VoidCallback goFullscreen;
  final bool isFullscreen;
  final List<charts.Series<MapEntry<DateTime, int>, DateTime>> grades;

  GradesChart({
    Key key,
    Map<SubjectGrades, SubjectGraphConfig> graphs,
    this.goFullscreen,
    this.isFullscreen,
  })  : grades = convert(graphs),
        super(key: key);

  static List<charts.Series<MapEntry<DateTime, int>, DateTime>> convert(
      Map<SubjectGrades, SubjectGraphConfig> data) {
    return data.entries
        .map(
          (entry) {
            final s = entry.key;
            final strokeWidth = entry.value.thick;
            final color = Color(entry.value.color);
            return strokeWidth == 0
                ? null
                : charts.Series<MapEntry<DateTime, int>, DateTime>(
                    colorFn: (_, __) => charts.Color(
                      r: color.red,
                      g: color.green,
                      b: color.blue,
                    ),
                    domainFn: (grade, _) => grade.key,
                    measureFn: (grade, _) => grade.value / 100,
                    data: s.grades.entries.toList(),
                    strokeWidthPxFn: (_, __) => strokeWidth,
                    id: "Grades",
                  );
          },
        )
        .where((v) => v != null)
        .toList();
  }

  List<charts.TickSpec<DateTime>> createDomainAxisTags(Locale locale) {
    DateTime first;
    DateTime last;
    // find the first given date and the last given date
    for (final subject in grades) {
      if (subject.data.isEmpty) continue;
      final firstSubjectDate = subject.data.first.key;
      assert(subject.data.every((e) => !e.key.isBefore(firstSubjectDate)));
      final lastSubjectDate = subject.data.last.key;
      assert(subject.data.every((e) => !e.key.isAfter(lastSubjectDate)));
      if (first == null || firstSubjectDate.isBefore(first)) {
        first = firstSubjectDate;
      }
      if (last == null || lastSubjectDate.isAfter(last)) {
        last = lastSubjectDate;
      }
    }
    // This means that there are no grades available
    if (first == null) return [];
    // Preferrably show all ticks on the 15th.
    // However, if the first date is after the 15th, show the tick there to make
    // sure all months are represented as ticks.
    final dates = [
      DateTime(first.year, first.month, first.day < 15 ? 15 : first.day)
    ];
    // Collect all 15th's that are before the last date
    while (true) {
      final newDate = DateTime(dates.last.year, dates.last.month + 1, 15);
      if (last.isBefore(newDate)) break;
      dates.add(newDate);
    }
    // make sure the last month is included
    if (dates.last.month != last.month) dates.add(last);
    // if the dates are in only one month, show ticks for the first and the last
    // one. Also include the day in the label in this case.
    // If there is only one date, show one tick for it.
    if (dates.length == 1) {
      return (first == last ? [first] : [first, last]).map((date) {
        return charts.TickSpec(
          date,
          label: DateFormat.MMMd(
            locale.toLanguageTag(),
          ).format(date),
        );
      }).toList();
    } else {
      return dates.map((date) {
        return charts.TickSpec(
          date,
          label: DateFormat.MMM(
            locale.toLanguageTag(),
          ).format(date),
        );
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final darkMode = Theme.of(context).brightness == Brightness.dark;
    return Hero(
      tag: 1337,
      child: maybeWrap(
          Center(
            child: charts.TimeSeriesChart(
              grades,
              animate: false,
              behaviors: isFullscreen
                  ? [
                      charts.SelectNearest(
                        eventTrigger: charts.SelectionTrigger.tapAndDrag,
                      ),
                    ]
                  : null,
              primaryMeasureAxis: charts.NumericAxisSpec(
                tickProviderSpec: const charts.StaticNumericTickProviderSpec(
                  [
                    charts.TickSpec(3),
                    charts.TickSpec(4),
                    charts.TickSpec(5),
                    charts.TickSpec(6),
                    charts.TickSpec(7),
                    charts.TickSpec(8),
                    charts.TickSpec(9),
                    charts.TickSpec(10),
                  ],
                ),
                renderSpec: charts.GridlineRendererSpec(
                  labelStyle: charts.TextStyleSpec(
                    fontSize: 10,
                    color: darkMode
                        ? charts.MaterialPalette.white
                        : charts.MaterialPalette.black,
                  ),
                  lineStyle: charts.LineStyleSpec(
                    thickness: 0,
                    color: charts.MaterialPalette.gray.shadeDefault,
                  ),
                ),
              ),
              defaultInteractions: isFullscreen,
              domainAxis: charts.DateTimeAxisSpec(
                tickProviderSpec: charts.StaticDateTimeTickProviderSpec(
                  createDomainAxisTags(
                    Localizations.localeOf(context),
                  ),
                ),
                renderSpec: charts.SmallTickRendererSpec(
                  labelStyle: charts.TextStyleSpec(
                    fontSize: 10,
                    color: darkMode
                        ? charts.MaterialPalette.white
                        : charts.MaterialPalette.black,
                  ),
                  lineStyle: charts.LineStyleSpec(
                    thickness: 0,
                    color: charts.MaterialPalette.gray.shadeDefault,
                  ),
                ),
              ),
            ),
          ), (widget) {
        return GestureDetector(
          onTap: goFullscreen,
          child: Stack(
            children: <Widget>[
              widget,
              const Positioned(
                right: 20,
                bottom: 20,
                child: Icon(Icons.fullscreen),
              ),
            ],
          ),
        );
      }, wrap: !isFullscreen),
    );
  }
}
