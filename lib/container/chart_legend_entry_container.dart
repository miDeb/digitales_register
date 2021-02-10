import 'package:built_value/built_value.dart';
import 'package:dr/ui/grades_chart_legend_entry.dart';
import 'package:flutter/material.dart' hide Builder;
import 'package:flutter_built_redux/flutter_built_redux.dart';

import '../actions/app_actions.dart';
import '../app_state.dart';

part 'chart_legend_entry_container.g.dart';

class ChartLegendEntryContainer extends StatelessWidget {
  final String subjectName;

  const ChartLegendEntryContainer({Key? key, required this.subjectName})
      : super(key: key);
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
        ..config = state.settingsState!.subjectThemes[name]!.toBuilder(),
    );
  }
}
