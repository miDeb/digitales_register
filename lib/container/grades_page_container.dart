import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../actions.dart';
import '../app_state.dart';
import '../ui/grades_page.dart';

class GradesPageContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, GradesPageViewModel>(
      builder: (BuildContext context, GradesPageViewModel vm) {
        return GradesPage(
          vm: vm,
        );
      },
      converter: (Store store) {
        return GradesPageViewModel.from(store);
      },
    );
  }
}

class GradesPageViewModel {
  final Semester showSemester;
  final ValueChanged<Semester> changeSemester;
  final String allSubjectsAverage;
  final bool loading;
  final bool showGradesDiagram;
  final bool showAllSubjectsAverage;

  GradesPageViewModel.from(Store<AppState> store)
      : showSemester = store.state.gradesState.semester,
        allSubjectsAverage = calculateAllSubjectsAverage(store.state),
        changeSemester = ((newSemester) =>
            store.dispatch(SetGradesSemesterAction(newSemester))),
        loading = store.state.gradesState.loading,
        showGradesDiagram = store.state.settingsState.showGradesDiagram,
        showAllSubjectsAverage =
            store.state.settingsState.showAllSubjectsAverage;

  static String calculateAllSubjectsAverage(AppState state) {
    var sum = 0;
    var n = 0;
    for (final allSemesterSubject in state.gradesState.subjects) {
      final subject = state.gradesState.semester.n == null
          ? allSemesterSubject
          : allSemesterSubject.subjects[state.gradesState.semester.n];
      final average = subject.average;
      if (average != null) {
        sum += average;
        n++;
      }
    }
    if (n == 0) {
      return "/";
    } else {
      return ((sum / n) / 100).toStringAsFixed(2);
    }
  }
}
