import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_built_redux/flutter_built_redux.dart';

import '../actions/app_actions.dart';
import '../app_state.dart';
import '../ui/grades_chart_legend.dart';

class ChartLegendContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnection<AppState, AppActions, BuiltList<String>>(
      builder: (context, vm, actions) {
        return ChartLegend(
          vm: vm,
        );
      },
      connect: (state) {
        return state.settingsState.subjectThemes.keys.toBuiltList();
      },
    );
  }
}
