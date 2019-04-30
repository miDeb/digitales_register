import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../actions.dart';
import '../app_state.dart';
import '../data.dart';
import '../ui/grades_chart.dart';

class GradesChartContainer extends StatelessWidget {
  final bool isFullscreen;

  const GradesChartContainer({Key key, this.isFullscreen}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, GradesChartViewModel>(
      converter: (Store<AppState> store) {
        return GradesChartViewModel(
          Map.fromIterable(
            store.state.gradesState.subjects.map((ass) {
              if (store.state.gradesState.semester.n != null) {
                return ass.subjects[store.state.gradesState.semester.n];
              } else
                return ass;
            }),
            key: (s) => SubjectGrades(
                  Map.fromIterable(
                    List<Grade>.of((s as Subject).grades)
                      ..removeWhere((g) => g.cancelled || g.grade == null),
                    key: (g) => (g as Grade).date,
                    value: (g) => (g as Grade).grade,
                  ),
                ),
            value: (s) =>
                store.state.gradesState.graphConfigs[(s as Subject).id],
          ),
          isFullscreen,
          () => store.dispatch(ShowFullscreenChartAciton()),
        );
      },
      builder: (BuildContext context, GradesChartViewModel vm) {
        return GradesChart(vm: vm);
      },
    );
  }
}

class GradesChartViewModel {
  final Map<SubjectGrades, SubjectGraphConfig> graphs;
  final bool isFullScreen;
  final VoidCallback goFullScreen;

  GradesChartViewModel(this.graphs, this.isFullScreen, this.goFullScreen);
}

class SubjectGrades {
  final Map<DateTime, int> grades;

  SubjectGrades(this.grades);
}
