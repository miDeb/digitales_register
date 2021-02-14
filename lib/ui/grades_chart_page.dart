import 'package:flutter/material.dart';

import '../container/chart_legend_container.dart';
import '../container/grades_chart_container.dart';

class GradesChartPage extends StatelessWidget {
  const GradesChartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notendiagramm"),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Expanded(
            child: GradesChartContainer(
              isFullscreen: true,
            ),
          ),
          ChartLegendContainer(),
        ],
      ),
    );
  }
}
