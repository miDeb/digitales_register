import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:flutter/material.dart' hide Builder;
import 'package:flutter_built_redux/flutter_built_redux.dart';

import '../actions/app_actions.dart';
import '../app_state.dart';
import '../data.dart';
import '../ui/homework_filter.dart';

part 'homework_filter_container.g.dart';

class HomeworkFilterContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnection<AppState, AppActions, HomeworkFilterVM>(
      builder: (context, vm, actions) {
        return HomeworkFilter(
          vm: vm,
          callback: (list) =>
              actions.dashboardActions.updateBlacklist(list.build()),
        );
      },
      connect: (AppState state) {
        return HomeworkFilterVM(
          (b) => b
            ..currentBlacklist = state.dashboardState.blacklist.toBuilder()
            ..allTypes = HomeworkType.values.toBuilder(),
        );
      },
    );
  }
}

typedef HomeworkBlacklistCallback = void Function(List<HomeworkType> blacklist);

abstract class HomeworkFilterVM
    implements Built<HomeworkFilterVM, HomeworkFilterVMBuilder> {
  BuiltList<HomeworkType> get currentBlacklist;
  BuiltSet<HomeworkType> get allTypes;

  factory HomeworkFilterVM([void Function(HomeworkFilterVMBuilder) updates]) =
      _$HomeworkFilterVM;
  HomeworkFilterVM._();
}
