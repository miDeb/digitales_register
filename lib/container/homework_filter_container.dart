import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_built_redux/flutter_built_redux.dart';

import '../actions/app_actions.dart';
import '../app_state.dart';
import '../data.dart';
import '../ui/homework_filter.dart';

class HomeworkFilterContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnection<AppState, AppActions, HomeworkFilterVM>(
      builder: (context, vm, actions) {
        return HomeworkFilter(
          vm: vm,
          callback: (list) => actions.dashboardActions.updateBlacklist(
            BuiltList.of(list),
          ),
        );
      },
      connect: (AppState state) {
        return HomeworkFilterVM(
          state.dashboardState.blacklist.toList(),
          HomeworkType.values.toList(),
        );
      },
    );
  }
}

typedef void HomeworkBlacklistCallback(List<HomeworkType> blacklist);

class HomeworkFilterVM {
  final List<HomeworkType> currentBlacklist;
  final List<HomeworkType> allTypes;

  HomeworkFilterVM(this.currentBlacklist, this.allTypes);
}
