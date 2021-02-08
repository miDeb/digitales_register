import 'dart:collection';

import 'package:charts_flutter/flutter.dart' as charts;
// ignore: implementation_imports
import 'package:charts_flutter/src/base_chart_state.dart';
import 'package:charts_common/common.dart' as common;

class TimeSeriesChart extends charts.TimeSeriesChart {
  TimeSeriesChart(
    List<common.Series<dynamic, DateTime>> seriesList, {
    bool animate,
    Duration animationDuration,
    common.AxisSpec domainAxis,
    common.AxisSpec primaryMeasureAxis,
    common.AxisSpec secondaryMeasureAxis,
    LinkedHashMap<String, common.NumericAxisSpec> disjointMeasureAxes,
    common.SeriesRendererConfig<DateTime> defaultRenderer,
    List<common.SeriesRendererConfig<DateTime>> customSeriesRenderers,
    List<charts.ChartBehavior> behaviors,
    List<charts.SelectionModelConfig<DateTime>> selectionModels,
    charts.LayoutConfig layoutConfig,
    common.DateTimeFactory dateTimeFactory,
    bool defaultInteractions = true,
    bool flipVerticalAxis,
    charts.UserManagedState<DateTime> userManagedState,
  }) : super(
          seriesList,
          animate: animate,
          animationDuration: animationDuration,
          domainAxis: domainAxis,
          primaryMeasureAxis: primaryMeasureAxis,
          secondaryMeasureAxis: secondaryMeasureAxis,
          disjointMeasureAxes: disjointMeasureAxes,
          defaultRenderer: defaultRenderer,
          customSeriesRenderers: customSeriesRenderers,
          behaviors: behaviors,
          selectionModels: selectionModels,
          layoutConfig: layoutConfig,
          defaultInteractions: defaultInteractions,
          flipVerticalAxis: flipVerticalAxis,
          userManagedState: userManagedState,
          dateTimeFactory: dateTimeFactory,
        );

  @override
  common.TimeSeriesChart createCommonChart(BaseChartState chartState) {
    return CommonTimeSeriesChart(
      layoutConfig: layoutConfig?.commonLayoutConfig,
      primaryMeasureAxis:
          primaryMeasureAxis?.createAxis() as charts.NumericAxis,
      secondaryMeasureAxis:
          secondaryMeasureAxis?.createAxis() as charts.NumericAxis,
      disjointMeasureAxes: createDisjointMeasureAxes(),
    );
  }
}

class CommonTimeSeriesChart extends common.TimeSeriesChart {
  CommonTimeSeriesChart(
      {bool vertical,
      common.LayoutConfig layoutConfig,
      common.NumericAxis primaryMeasureAxis,
      common.NumericAxis secondaryMeasureAxis,
      LinkedHashMap<String, common.NumericAxis> disjointMeasureAxes})
      : super(
            vertical: vertical,
            layoutConfig: layoutConfig,
            primaryMeasureAxis: primaryMeasureAxis,
            secondaryMeasureAxis: secondaryMeasureAxis,
            disjointMeasureAxes: disjointMeasureAxes);

// ALL OF THIS FILE is solely needed to override this value:
// It causes the selection to also account for the vertical distance from the tap location.
  @override
  bool get selectNearestByDomain => false;
}
