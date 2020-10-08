import 'package:dr/util.dart';
import 'package:flutter/material.dart' hide Builder;
import 'package:flutter_built_redux/flutter_built_redux.dart';

import '../actions/app_actions.dart';
import '../app_state.dart';
import '../ui/grades_page.dart';

import 'package:built_value/built_value.dart';

part 'grades_page_container.g.dart';

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

abstract class GradesPageViewModel
    implements Built<GradesPageViewModel, GradesPageViewModelBuilder> {
  Semester get showSemester;
  String get allSubjectsAverage;
  bool get loading;
  bool get showGradesDiagram;
  bool get showAllSubjectsAverage;
  bool get hasData;
  bool get noInternet;

  factory GradesPageViewModel.from(AppState state) {
    return GradesPageViewModel((b) => b
      ..showSemester = state.gradesState.semester.toBuilder()
      ..loading = state.gradesState.loading
      ..allSubjectsAverage = calculateAllSubjectsAverage(state)
      ..hasData = state.gradesState.subjects.any(
        (s) => state.gradesState.semester != Semester.all
            ? s.gradesAll.containsKey(state.gradesState.semester)
            : s.gradesAll.isNotEmpty,
      )
      ..noInternet = state.noInternet
      ..showGradesDiagram = state.settingsState.showGradesDiagram
      ..showAllSubjectsAverage = state.settingsState.showAllSubjectsAverage &&
          state.gradesState.semester.n != null);
  }

  GradesPageViewModel._();
  factory GradesPageViewModel(
          [void Function(GradesPageViewModelBuilder) updates]) =
      _$GradesPageViewModel;
}

String calculateAllSubjectsAverage(AppState state) {
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
