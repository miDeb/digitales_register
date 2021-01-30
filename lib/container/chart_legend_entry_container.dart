import 'package:built_value/built_value.dart';
import 'package:dr/ui/grades_chart_legend_entry.dart';
import 'package:flutter/material.dart' hide Builder;
import 'package:flutter_built_redux/flutter_built_redux.dart';

import '../actions/app_actions.dart';
import '../app_state.dart';

part 'chart_legend_entry_container.g.dart';

class ChartLegendEntryContainer extends StatelessWidget {
  final int id;

  const ChartLegendEntryContainer({Key key, this.id}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StoreConnection<AppState, AppActions, ChartLegendEntryVM>(
      builder: (context, vm, actions) {
        return GradesChartLegendEntry(
          config: vm.config,
          name: vm.name,
          setThickness: (thickness) {
            actions.settingsActions.setGraphConfig(
              MapEntry(
                id,
                vm.config.rebuild(
                  (b) => b.thick = thickness,
                ),
              ),
            );
          },
        );
      },
      connect: (state) {
        return ChartLegendEntryVM.from(state, id);
      },
    );
  }
}

abstract class ChartLegendEntryVM
    implements Built<ChartLegendEntryVM, ChartLegendEntryVMBuilder> {
  String get name;
  SubjectGraphConfig get config;

  factory ChartLegendEntryVM(
          [void Function(ChartLegendEntryVMBuilder) updates]) =
      _$ChartLegendEntryVM;
  ChartLegendEntryVM._();

  factory ChartLegendEntryVM.from(AppState state, int id) {
    return ChartLegendEntryVM(
      (b) => b
        ..name = state.gradesState.subjects.firstWhere((s) => s.id == id).name
        ..config = state.settingsState.graphConfigs[id].toBuilder(),
    );
  }
}
