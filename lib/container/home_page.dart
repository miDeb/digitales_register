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

import 'package:built_value/built_value.dart';

import 'package:flutter/material.dart' hide Builder;
import 'package:flutter_built_redux/flutter_built_redux.dart';

import '../actions/app_actions.dart';
import '../app_state.dart';
import '../ui/home_page_content.dart';

part 'home_page.g.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnection<AppState, AppActions, HomePageContentViewModel>(
      builder: (context, vm, actions) {
        return HomePageContent(
          vm: vm,
        );
      },
      connect: (state) {
        return HomePageContentViewModel.from(state);
      },
    );
  }
}

abstract class HomePageContentViewModel
    implements
        Built<HomePageContentViewModel, HomePageContentViewModelBuilder> {
  bool get splash;

  factory HomePageContentViewModel(
          [void Function(HomePageContentViewModelBuilder)? updates]) =
      _$HomePageContentViewModel;
  HomePageContentViewModel._();

  factory HomePageContentViewModel.from(AppState state) {
    return HomePageContentViewModel(
      (b) => b..splash = !state.loginState.loggedIn,
    );
  }
}
