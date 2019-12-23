import 'package:flutter/material.dart';
import 'package:flutter_built_redux/flutter_built_redux.dart';

import '../actions/app_actions.dart';
import '../app_state.dart';
import '../ui/home_page_content.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnection<AppState, AppActions, HomePageContentViewModel>(
      builder: (context, vm, actions) {
        return HomePageContent(
          vm: vm,
          refreshNoInternet: actions.refreshNoInternet,
        );
      },
      connect: (state) {
        return HomePageContentViewModel.from(state);
      },
    );
  }
}

class HomePageContentViewModel {
  final bool noInternet, loading, splash;
  final String userName, userIcon;
  HomePageContentViewModel.from(AppState state)
      : noInternet = state.noInternet,
        loading = state.dashboardState.loading,
        userName = state.config?.fullName ?? state.loginState.userName,
        userIcon = state.config?.imgSource,
        splash = !state.loginState.loggedIn;
  @override
  String toString() {
    return "HomePageContentViewModel(noInternet: $noInternet, loading: $loading)";
  }
}
