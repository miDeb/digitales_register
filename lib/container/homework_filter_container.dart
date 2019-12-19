import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:built_collection/built_collection.dart';

import '../actions/dashboard_actions.dart';
import '../app_state.dart';
import '../data.dart';
import '../ui/homework_filter.dart';

class HomeworkFilterContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, HomeworkFilterVM>(
      builder: (BuildContext context, HomeworkFilterVM vm) {
        return HomeworkFilter(vm: vm);
      },
      converter: (Store<AppState> store) {
        return HomeworkFilterVM(
          store.state.dayState.blacklist.toList(),
          (newBlacklist) => store.dispatch(
            UpdateHomeworkFilterBlacklistAction(
              (b) => b..blacklist = ListBuilder(newBlacklist),
            ),
          ),
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
  final HomeworkBlacklistCallback callback;

  HomeworkFilterVM(this.currentBlacklist, this.callback, this.allTypes);
}
