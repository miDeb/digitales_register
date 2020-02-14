import 'package:dr/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_built_redux/flutter_built_redux.dart';

import '../actions/app_actions.dart';
import '../app_state.dart';
import '../ui/grades_page.dart';

class GradesPageContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnection<AppState, AppActions, GradesPageViewModel>(
      builder: (context, vm, actions) {
        return GradesPage(
          vm: vm,
          changeSemester: actions.gradesActions.setSemester,
        );
      },
      connect: (state) {
        return GradesPageViewModel.from(state);
      },
    );
  }
}

class GradesPageViewModel {
  final Semester showSemester;
  final String allSubjectsAverage;
  final bool loading;
  final bool showGradesDiagram;
  final bool showAllSubjectsAverage;
  final bool hasData;
  final bool noInternet;

  GradesPageViewModel.from(AppState state)
      : showSemester = state.gradesState.semester,
        loading = state.gradesState.loading,
        allSubjectsAverage = calculateAllSubjectsAverage(state),
        hasData = state.gradesState.subjects.any(
          (s) => state.gradesState.semester != Semester.all
              ? s.gradesAll.containsKey(state.gradesState.semester)
              : s.gradesAll.isNotEmpty,
        ),
        noInternet = state.noInternet,
        showGradesDiagram = state.settingsState.showGradesDiagram,
        showAllSubjectsAverage = state.settingsState.showAllSubjectsAverage &&
            state.gradesState.semester.n != null;

  static String calculateAllSubjectsAverage(AppState state) {
    if (state.gradesState.semester == Semester.all) return null;
    var sum = 0;
    var n = 0;
    for (final subject in state.gradesState.subjects) {
      final average = subject.average(state.gradesState.semester);
      if (average != null) {
        sum += average;
        n++;
      }
    }
    if (n == 0) {
      return "/";
    } else {
      return gradeAverageFormat.format(sum / n / 100);
    }
  }
}
