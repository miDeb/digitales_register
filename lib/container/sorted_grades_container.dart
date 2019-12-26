import 'package:flutter/material.dart';
import 'package:flutter_built_redux/flutter_built_redux.dart';

import '../actions/app_actions.dart';
import '../actions/grades_actions.dart';
import '../app_state.dart';
import '../data.dart';
import '../ui/sorted_grades_widget.dart';

class SortedGradesContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnection<AppState, AppActions, SortedGradesViewModel>(
      connect: (state) {
        return SortedGradesViewModel(state);
      },
      builder: (context, vm, actions) {
        return SortedGradesWidget(
          vm: vm,
          showCancelledCallback: actions.settingsActions.showCancelledGrades,
          sortByTypeCallback: actions.settingsActions.gradesTypeSorted,
          viewSubjectDetail: (s) => actions.gradesActions.loadDetails(
            LoadSubjectDetailsPayload(
              (b) => b
                ..subject = s.toBuilder()
                ..semester = vm.semester.toBuilder(),
            ),
          ),
        );
      },
    );
  }
}

typedef void ViewSubjectDetailCallback(Subject s);
typedef void SetBoolCallback(bool byType);

class SortedGradesViewModel {
  final List<Subject> subjects;
  final Semester semester;
  final bool sortByType, showCancelled, noInternet;
  SortedGradesViewModel(AppState state)
      : subjects = state.gradesState.subjects.toList(),
        sortByType = state.settingsState.typeSorted,
        semester = state.gradesState.semester,
        showCancelled = state.settingsState.showCancelled,
        noInternet = state.noInternet;
}
