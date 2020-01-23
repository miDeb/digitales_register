import 'package:flutter/material.dart';
import 'package:flutter_built_redux/flutter_built_redux.dart';

import '../actions/app_actions.dart';
import '../app_state.dart';
import '../data.dart';
import '../ui/grades_chart.dart';

class GradesChartContainer extends StatelessWidget {
  final bool isFullscreen;

  const GradesChartContainer({Key key, this.isFullscreen}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnection<AppState, AppActions, Map<SubjectGrades, SubjectGraphConfig>>(
      connect: (state) {
        return Map.fromIterable(
          state.gradesState.subjects,
          key: (subject) {
            final grades = state.gradesState.semester == Semester.all
                ? subject.gradesAll.values
                    .fold<List<GradeAll>>(<GradeAll>[], (a, b) => <GradeAll>[...a, ...b])
                : subject.gradesAll[state.gradesState.semester].toList();

            return SubjectGrades(
              Map.fromIterable(
                grades..removeWhere((g) => g.cancelled || g.grade == null),
                key: (g) => (g as GradeAll).date,
                value: (g) => (g as GradeAll).grade,
              ),
            );
          },
          value: (s) => state.settingsState.graphConfigs[(s as Subject).id],
        );
      },
      builder: (context, vm, actions) {
        return GradesChart(
          graphs: vm,
          isFullscreen: isFullscreen,
          goFullscreen: actions.routingActions.showGradesChart,
        );
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
