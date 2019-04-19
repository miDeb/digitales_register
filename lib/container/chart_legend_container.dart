import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../actions.dart';
import '../app_state.dart';
import '../ui/grades_chart_legend.dart';

class ChartLegendContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ChartLegendViewModel>(
      builder: (BuildContext context, ChartLegendViewModel vm) {
        return ChartLegend(vm: vm);
      },
      distinct: true,
      converter: (Store<AppState> store) {
        return ChartLegendViewModel(
            store.state.gradesState.graphConfigs
                .map(
                  (id, config) => MapEntry(
                      store.state.gradesState.subjects
                          .firstWhere((s) => s.id == id)
                          .name,
                      config),
                )
                .toMap(), (name, thick) {
          final id = store.state.gradesState.subjects
              .firstWhere((s) => s.name == name)
              .id;
          final configs = store.state.gradesState.graphConfigs.toBuilder();
          configs.updateValue(id, (config) {
            return config.rebuild((b) => b.thick = thick);
          });
          store.dispatch(SetGraphConfigsAction(configs.build().toMap()));
        });
      },
    );
  }
}

Function deepEq = const DeepCollectionEquality().equals;

typedef void ChangeThick(String s, int thick);

class ChartLegendViewModel {
  final Map<String, SubjectGraphConfig> configs;
  final ChangeThick onChangeThick;

  @override
  operator ==(other) {
    return other is ChartLegendViewModel ?? deepEq(configs, other.configs);
  }

  ChartLegendViewModel(this.configs, this.onChangeThick);
}
