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
            ..currentBlacklist = state.dashboardState.blacklist!.toBuilder()
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

  factory HomeworkFilterVM([void Function(HomeworkFilterVMBuilder)? updates]) =
      _$HomeworkFilterVM;
  HomeworkFilterVM._();
}
