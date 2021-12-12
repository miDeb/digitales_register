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
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:dr/l10n/l10n.dart' as l10n;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tuple/tuple.dart';

import '../app_state.dart';
import '../container/grades_chart_container.dart';
import '../data.dart';
import '../utc_date_time.dart';

class _Selection {
  final String text;
  final Color color;

  _Selection(this.text, this.color);
}

class GradesChart extends StatelessWidget {
  final VoidCallback? goFullscreen;
  final bool isFullscreen;
  final List<
          charts
              .Series<MapEntry<UtcDateTime, Tuple2<int, String>>, UtcDateTime>>
      grades;

  final ValueNotifier<Tuple2<UtcDateTime, BuiltList<_Selection>>?> selection =
      ValueNotifier(null);

  GradesChart({
    Key? key,
    required Map<SubjectGrades, SubjectTheme> graphs,
    this.goFullscreen,
    required this.isFullscreen,
  })  : grades = convert(graphs),
        super(key: key);

  static List<
          charts
              .Series<MapEntry<UtcDateTime, Tuple2<int, String>>, UtcDateTime>>
      convert(Map<SubjectGrades, SubjectTheme> data) {
    return data.entries.where((entry) => entry.value.thick != 0).map(
      (entry) {
        final s = entry.key;
        final strokeWidth = entry.value.thick;
        final color = Color(entry.value.color);
        return charts.Series<MapEntry<UtcDateTime, Tuple2<int, String>>,
            UtcDateTime>(
          domainFn: (grade, _) => grade.key,
          measureFn: (grade, _) => grade.value.item1 / 100,
          data: s.grades.entries.toList(),
          strokeWidthPxFn: (_, __) => strokeWidth,
          id: s.name,
          seriesColor: charts.Color(
            r: color.red,
            g: color.green,
            b: color.blue,
          ),
        );
      },
    ).toList();
  }

  List<charts.TickSpec<UtcDateTime>> createDomainAxisTags(Locale locale) {
    UtcDateTime? first;
    UtcDateTime? last;
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
    if (first == null || last == null) return [];
    // Preferrably show all ticks on the 15th.
    // However, if the first date is after the 15th, show the tick there to make
    // sure all months are represented as ticks.
    final dates = [
      UtcDateTime(first.year, first.month, first.day < 15 ? 15 : first.day)
    ];
    // Collect all 15th's that are before the last date
    while (true) {
      final newDate = UtcDateTime(dates.last.year, dates.last.month + 1, 15);
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

  charts.DateTimeExtents? dateTimeExtents() {
    DateTime? first;
    DateTime? last;
    for (final subject in grades) {
      for (final grade in subject.data) {
        if (first == null || grade.key.isBefore(first)) first = grade.key;
        if (last == null || grade.key.isAfter(last)) last = grade.key;
      }
    }
    if (first == null || last == null) return null;
    // Add some padding to avoid cutting off the graph at the edge of the diagram
    final padding = Duration(hours: last.difference(first).inHours ~/ 100);
    return charts.DateTimeExtents(
      start: first.subtract(padding),
      end: last.add(padding),
    );
  }

  @override
  Widget build(BuildContext context) {
    final darkMode = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: isFullscreen ? null : goFullscreen,
      child: Stack(
        children: [
          Hero(
            tag: 1337,
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
              defaultRenderer: charts.LineRendererConfig(
                includePoints: isFullscreen,
                radiusPx: 2,
                roundEndCaps: true,
              ),
              layoutConfig: charts.LayoutConfig(
                bottomMarginSpec: charts.MarginSpec.fixedPixel(16),
                rightMarginSpec: charts.MarginSpec.fixedPixel(8),
                leftMarginSpec: charts.MarginSpec.fixedPixel(20),
                topMarginSpec: charts.MarginSpec.fixedPixel(16),
              ),
              selectionModels: [
                charts.SelectionModelConfig(
                  changedListener: (model) {
                    UtcDateTime? allDate;
                    final selections = model.selectedDatum.map((datum) {
                      final grade = datum.datum.value.item1 as int;
                      final type = datum.datum.value.item2 as String;
                      final subject = datum.series.displayName;
                      final color = datum.series.colorFn!(0)!;
                      final date = datum.datum.key as UtcDateTime;
                      assert(allDate == null || allDate == date);
                      allDate = date;
                      return _Selection(
                        "$subject – $type: ${formatGradeFromInt(grade)}",
                        Color.fromARGB(
                          color.a,
                          color.r,
                          color.g,
                          color.b,
                        ),
                      );
                    }).toBuiltList();
                    if (allDate != null) {
                      selection.value = Tuple2(
                        allDate!,
                        selections,
                      );
                    } else {
                      selection.value = null;
                    }
                  },
                )
              ],
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
                viewport: dateTimeExtents(),
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
                  labelAnchor: charts.TickLabelAnchor.inside,
                  lineStyle: charts.LineStyleSpec(
                    thickness: 0,
                    color: charts.MaterialPalette.gray.shadeDefault,
                  ),
                ),
              ),
            ),
          ),
          if (isFullscreen)
            ValueListenableBuilder<Tuple2<UtcDateTime, BuiltList<_Selection>>?>(
                valueListenable: selection,
                builder: (context, data, _) {
                  return Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: SelectionWidget(
                        date: data?.item1,
                        selections: data?.item2,
                      ),
                    ),
                  );
                }),
          if (!isFullscreen)
            const Positioned(
              right: 20,
              bottom: 20,
              child: Icon(Icons.fullscreen),
            ),
        ],
      ),
    );
  }
}

class SelectionWidget extends StatelessWidget {
  final UtcDateTime? date;
  final BuiltList<_Selection>? selections;

  const SelectionWidget({Key? key, this.date, this.selections})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      layoutBuilder: (currentChild, previousChildren) => AnimatedSize(
        alignment: Alignment.topCenter,
        duration: const Duration(milliseconds: 150),
        curve: Curves.ease,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            ...previousChildren,
            if (currentChild != null) currentChild,
          ],
        ),
      ),
      duration: const Duration(milliseconds: 150),
      child: date != null && selections?.isNotEmpty == true
          ? Column(
              key: ValueKey(selections),
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.black,
                  ),
                  child: Text(
                    DateFormat.MMMMd().format(date!),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                for (final selection in selections!)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: selection.color,
                    ),
                    child: Text(
                      selection.text,
                      style: TextStyle(
                        color: ThemeData.estimateBrightnessForColor(
                                    selection.color) ==
                                Brightness.light
                            ? Colors.black
                            : Colors.white,
                      ),
                    ),
                  ),
              ],
            )
          : Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 2,
              ),
              margin: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.grey.shade700,
              ),
              child: Text(
                l10n.chartTapHint(),
                style: TextStyle(color: Colors.white),
              ),
            ),
    );
  }
}
