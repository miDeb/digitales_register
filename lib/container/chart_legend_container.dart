import 'package:flutter/material.dart';
import 'package:flutter_built_redux/flutter_built_redux.dart';
import 'package:tuple/tuple.dart';

import '../actions/app_actions.dart';
import '../app_state.dart';
import '../ui/grades_chart_legend.dart';

class ChartLegendContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnection<AppState, AppActions, Map<Tuple2<String, int>, SubjectGraphConfig>>(
      builder: (context, vm, actions) {
        return ChartLegend(
          vm: vm,
          onSetConfig: (id, config) {
            actions.settingsActions.setGraphConfig(MapEntry(id, config));
          },
        );
      },
      connect: (state) {
        return state.settingsState.graphConfigs
            .map(
              (id, config) => MapEntry(
                Tuple2(
                  state.gradesState.subjects.firstWhere((s) => s.id == id).name,
                  id,
                ),
                config,
              ),
            )
            .toMap();
      },
    );
  }
}

class ChartLegendViewModel {
  final Map<Tuple2<String, int>, SubjectGraphConfig> configs;
  ChartLegendViewModel(this.configs);
}
