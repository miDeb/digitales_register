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
          [void Function(HomePageContentViewModelBuilder) updates]) =
      _$HomePageContentViewModel;
  HomePageContentViewModel._();

  factory HomePageContentViewModel.from(AppState state) {
    return HomePageContentViewModel(
        (b) => b..splash = !state.loginState.loggedIn);
  }
}
