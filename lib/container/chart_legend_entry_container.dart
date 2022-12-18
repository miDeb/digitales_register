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
import 'package:dr/actions/app_actions.dart';
import 'package:dr/app_state.dart';
import 'package:dr/ui/grades_chart_legend_entry.dart';
import 'package:flutter/material.dart' hide Builder;
import 'package:flutter_built_redux/flutter_built_redux.dart';

part 'chart_legend_entry_container.g.dart';

class ChartLegendEntryContainer extends StatelessWidget {
  final String subjectName;

  const ChartLegendEntryContainer({super.key, required this.subjectName});
  @override
  Widget build(BuildContext context) {
    return StoreConnection<AppState, AppActions, ChartLegendEntryVM>(
      builder: (context, vm, actions) {
        return GradesChartLegendEntry(
          config: vm.config,
          name: vm.name,
          setThickness: (thickness) {
            actions.settingsActions.setSubjectTheme(
              MapEntry(
                subjectName,
                vm.config.rebuild(
                  (b) => b.thick = thickness,
                ),
              ),
            );
          },
        );
      },
      connect: (state) {
        return ChartLegendEntryVM.from(state, subjectName);
      },
    );
  }
}

abstract class ChartLegendEntryVM
    implements Built<ChartLegendEntryVM, ChartLegendEntryVMBuilder> {
  String get name;
  SubjectTheme get config;

  factory ChartLegendEntryVM(
          [void Function(ChartLegendEntryVMBuilder)? updates]) =
      _$ChartLegendEntryVM;
  ChartLegendEntryVM._();

  factory ChartLegendEntryVM.from(AppState state, String name) {
    return ChartLegendEntryVM(
      (b) => b
        ..name = name
        ..config = state.settingsState.subjectThemes[name]!.toBuilder(),
    );
  }
}
