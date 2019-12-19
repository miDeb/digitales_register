import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../actions/routing_actions.dart';
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
            store.state.gradesState.subjects,
            key: (subject) {
              final grades = store.state.gradesState.semester == Semester.all
                  ? subject.gradesAll.values.fold<List<GradeAll>>(
                      <GradeAll>[], (a, b) => <GradeAll>[...a, ...b])
                  : subject.gradesAll[store.state.gradesState.semester]
                      .toList();

              return SubjectGrades(
                Map.fromIterable(
                  grades..removeWhere((g) => g.cancelled || g.grade == null),
                  key: (g) => (g as GradeAll).date,
                  value: (g) => (g as GradeAll).grade,
                ),
              );
            },
            value: (s) =>
                store.state.settingsState.graphConfigs[(s as Subject).id],
          ),
          isFullscreen,
          () => store.dispatch(ShowFullscreenChartAction()),
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
