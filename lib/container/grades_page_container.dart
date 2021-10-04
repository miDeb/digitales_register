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

import 'package:built_value/built_value.dart';
import 'package:dr/util.dart';
import 'package:flutter/material.dart' hide Builder;
import 'package:flutter_built_redux/flutter_built_redux.dart';

import '../actions/app_actions.dart';
import '../app_state.dart';
import '../ui/grades_page.dart';

part 'grades_page_container.g.dart';

class GradesPageContainer extends StatelessWidget {
  const GradesPageContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnection<AppState, AppActions, GradesPageViewModel>(
      builder: (context, vm, actions) {
        return GradesPage(
          vm: vm,
          changeSemester: actions.gradesActions.setSemester,
          showGradesSettings:
              actions.routingActions.showEditGradesAverageSettings,
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

  factory GradesPageViewModel(
          [void Function(GradesPageViewModelBuilder)? updates]) =
      _$GradesPageViewModel;
  GradesPageViewModel._();

  factory GradesPageViewModel.from(AppState state) {
    return GradesPageViewModel(
      (b) => b
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
        ..showAllSubjectsAverage = state.settingsState.showAllSubjectsAverage,
    );
  }
}

String calculateAllSubjectsAverage(AppState state) {
  var sum = 0;
  var n = 0;
  for (final subject in state.gradesState.subjects) {
    final average = subject.average(state.gradesState.semester);
    if (average != null &&
        !state.settingsState.ignoreForGradesAverage.any(
          (element) => element.toLowerCase() == subject.name.toLowerCase(),
        )) {
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
