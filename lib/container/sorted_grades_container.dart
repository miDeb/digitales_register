import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:flutter/material.dart' hide Builder;
import 'package:flutter_built_redux/flutter_built_redux.dart';

import '../actions/app_actions.dart';
import '../actions/grades_actions.dart';
import '../app_state.dart';
import '../data.dart';
import '../ui/sorted_grades_widget.dart';

part 'sorted_grades_container.g.dart';

class SortedGradesContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnection<AppState, AppActions, SortedGradesViewModel>(
      connect: (state) {
        return SortedGradesViewModel.from(state);
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

typedef ViewSubjectDetailCallback = void Function(Subject s);
typedef SetBoolCallback = void Function(bool byType);

abstract class SortedGradesViewModel
    implements Built<SortedGradesViewModel, SortedGradesViewModelBuilder> {
  BuiltList<Subject> get subjects;
  BuiltList<String> get ignoredSubjectsForAverage;
  Semester get semester;
  bool get sortByType;
  bool get showCancelled;
  bool get noInternet;

  factory SortedGradesViewModel(
          [void Function(SortedGradesViewModelBuilder) updates]) =
      _$SortedGradesViewModel;
  SortedGradesViewModel._();

  factory SortedGradesViewModel.from(AppState state) {
    return SortedGradesViewModel(
      (b) => b
        ..subjects = state.gradesState.subjects.toBuilder()
        ..sortByType = state.settingsState.typeSorted
        ..semester = state.gradesState.semester.toBuilder()
        ..showCancelled = state.settingsState.showCancelled
        ..noInternet = state.noInternet
        ..ignoredSubjectsForAverage =
            state.settingsState.ignoreForGradesAverage.toBuilder(),
    );
  }
}
