import 'package:flutter/material.dart';
import 'package:flutter_built_redux/flutter_built_redux.dart';
import 'package:tuple/tuple.dart';

import '../actions/app_actions.dart';
import '../app_state.dart';
import '../data.dart';
import '../ui/grades_chart.dart';

class GradesChartContainer extends StatelessWidget {
  final bool isFullscreen;

  const GradesChartContainer({Key key, this.isFullscreen}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnection<AppState, AppActions,
        Map<SubjectGrades, SubjectTheme>>(
      connect: (state) {
        SubjectGrades getKey(Subject subject) {
          final grades = state.gradesState.semester == Semester.all
              ? (subject.gradesAll.values.fold<List<GradeAll>>(
                  <GradeAll>[], (a, b) => <GradeAll>[...a, ...b])
                ..sort((GradeAll a, GradeAll b) => a.date.compareTo(b.date)))
              : subject.gradesAll[state.gradesState.semester].toList();
          grades.removeWhere((grade) => grade.cancelled || grade.grade == null);

          return SubjectGrades(
            {
              for (final grade in grades)
                grade.date: Tuple2(grade.grade, grade.type),
            },
            subject.name,
          );
        }

        SubjectTheme getValue(Subject subject) {
          return state.settingsState.subjectThemes[subject.name];
        }

        return {
          for (final subject in state.gradesState.subjects)
            getKey(subject): getValue(subject)
        };
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

class SubjectGrades {
  final Map<DateTime, Tuple2<int, String>> grades;
  final String name;

  SubjectGrades(this.grades, this.name);
}
