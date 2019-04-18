import 'package:charts_flutter/flutter.dart' as chart;
import 'package:flutter/material.dart';

import '../app_state.dart';
import '../container/grades_chart_container.dart';
import '../util.dart';

final colors = List.of(Colors.primaries)
  ..remove(Colors.pink)
  ..remove(Colors.lightBlue)
  ..remove(Colors.lightGreen);

class GradesChart extends StatelessWidget {
  final GradesChartViewModel vm;
  final List<chart.Series<MapEntry<DateTime, int>, DateTime>> grades;

  GradesChart({Key key, this.vm})
      : grades = convert(vm.graphs),
        super(key: key);

  static List<chart.Series<MapEntry<DateTime, int>, DateTime>> convert(
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
                : chart.Series<MapEntry<DateTime, int>, DateTime>(
                    colorFn: (_, __) => chart.Color(
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

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 1337,
      child: maybeWrap(
          Center(
            child: chart.TimeSeriesChart(
              grades,
              animate: false,
              primaryMeasureAxis: chart.NumericAxisSpec(
                tickProviderSpec: chart.StaticNumericTickProviderSpec(
                  [
                    chart.TickSpec(3),
                    chart.TickSpec(4),
                    chart.TickSpec(5),
                    chart.TickSpec(6),
                    chart.TickSpec(7),
                    chart.TickSpec(8),
                    chart.TickSpec(9),
                    chart.TickSpec(10),
                  ],
                ),
              ),
              defaultInteractions: false,
              domainAxis: new chart.EndPointsTimeAxisSpec(),
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
