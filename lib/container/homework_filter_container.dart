import 'package:dr/actions.dart';
import 'package:dr/ui/homework_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../app_state.dart';
import '../data.dart';

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
            UpdateHomeworkFilterBlacklistAction(newBlacklist),
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
