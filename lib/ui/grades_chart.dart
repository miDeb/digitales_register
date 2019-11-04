import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../app_state.dart';
import '../container/grades_chart_container.dart';
import '../util.dart';

final colors = List.of(Colors.primaries)
  ..remove(Colors.pink)
  ..remove(Colors.lightBlue)
  ..remove(Colors.lightGreen);

class GradesChart extends StatelessWidget {
  final GradesChartViewModel vm;
  final List<charts.Series<MapEntry<DateTime, int>, DateTime>> grades;

  GradesChart({Key key, this.vm})
      : grades = convert(vm.graphs),
        super(key: key);

  static List<charts.Series<MapEntry<DateTime, int>, DateTime>> convert(
      Map<SubjectGrades, SubjectGraphConfig> data) {
    int count = 0;
    return data.entries
        .map(
          (entry) {
            final s = entry.key;
            final strokeWidth = entry.value.thick;
            final color = Color(entry.value.color) ?? colors[count++];
            return strokeWidth == 0
                ? null
                : charts.Series<MapEntry<DateTime, int>, DateTime>(
                    colorFn: (_, __) => charts.Color(
                        r: color.red, g: color.green, b: color.blue),
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
    var firstMonth;
    var lastMonth;
    for (final sub in grades) {
      if (sub.data.isEmpty) continue;
      final firstSubjectDate = sub.data.last.key;
      final lastSubjectDate = sub.data.first.key;
      if (firstMonth == null || firstSubjectDate.isBefore(firstMonth)) {
        firstMonth = firstSubjectDate;
      }
      if (lastMonth == null || lastSubjectDate.isAfter(lastMonth)) {
        lastMonth = lastSubjectDate;
      }
    }
    if(firstMonth == null) return [];
    final dates = [
      DateTime(firstMonth.year, firstMonth.month,
          firstMonth.day < 15 ? 15 : firstMonth.day)
    ];
    while (true) {
      final newDate = DateTime(dates.last.year, dates.last.month + 1, 15);
      if (lastMonth.isBefore(newDate)) break;
      dates.add(newDate);
    }
    if (dates.last.month != lastMonth.month) dates.add(lastMonth);
    if (dates.length == 1) {
      return [firstMonth, lastMonth].map((date) {
        return charts.TickSpec(
          date,
          label: DateFormat.MMMMd(
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
    return Hero(
      tag: 1337,
      child: maybeWrap(
          Center(
            child: charts.TimeSeriesChart(
              grades,
              animate: false,
              primaryMeasureAxis: charts.NumericAxisSpec(
                tickProviderSpec: charts.StaticNumericTickProviderSpec(
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
              ),
              defaultInteractions: false,
              domainAxis: new charts.DateTimeAxisSpec(
                tickProviderSpec: charts.StaticDateTimeTickProviderSpec(
                  createDomainAxisTags(
                    Localizations.localeOf(context),
                  ),
                ),
              ),
            ),
          ),
          !vm.isFullScreen, (widget) {
        return GestureDetector(
          child: Stack(
            children: <Widget>[
              widget,
              Positioned(
                child: Icon(Icons.fullscreen),
                right: 20,
                bottom: 20,
              ),
            ],
          ),
          onTap: () => vm.goFullScreen(),
        );
      }),
    );
  }
}
