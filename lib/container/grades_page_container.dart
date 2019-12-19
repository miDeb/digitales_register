import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../actions/grades_actions.dart';
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
        changeSemester = ((newSemester) => store.dispatch(
              SetSemesterAction(
                (b) => b..semester = newSemester.toBuilder(),
              ),
            )),
        loading = store.state.gradesState.loading,
        allSubjectsAverage = calculateAllSubjectsAverage(store.state),
        showGradesDiagram = store.state.settingsState.showGradesDiagram,
        showAllSubjectsAverage =
            store.state.settingsState.showAllSubjectsAverage &&
                store.state.gradesState.semester.n != null;

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
      return ((sum / n) / 100).toStringAsFixed(2);
    }
  }
}
