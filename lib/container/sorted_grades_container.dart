// Copyright (C) 2021 Michael Debertol
//
// This file is part of digitales_register.
//
// digitales_register is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// digitales_register is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with digitales_register.  If not, see <http://www.gnu.org/licenses/>.

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:dr/actions/app_actions.dart';
import 'package:dr/actions/grades_actions.dart';
import 'package:dr/app_state.dart';
import 'package:dr/data.dart';
import 'package:dr/ui/sorted_grades_widget.dart';
import 'package:flutter/material.dart' hide Builder;
import 'package:flutter_built_redux/flutter_built_redux.dart';

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
          showGradeCalculator: actions.routingActions.showGradeCalculator,
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
  bool? get showCancelled;
  bool get noInternet;

  factory SortedGradesViewModel(
          [void Function(SortedGradesViewModelBuilder)? updates]) =
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
