import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../actions.dart';
import '../app_state.dart';
import '../ui/home_page_content.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, HomePageContentViewModel>(
      builder: (context, vm) {
        return HomePageContent(vm: vm);
      },
      converter: (store) {
        return HomePageContentViewModel.from(store);
      },
    );
  }
}

class HomePageContentViewModel {
  final bool noInternet, hasDays, loading, splash;
  final VoidCallback refresh, refreshNoInternet;
  final String userName, userIcon;
  HomePageContentViewModel.from(Store<AppState> store)
      : noInternet = store.state.noInternet,
        hasDays = store.state.dayState.hasDays,
        loading = store.state.dayState.loading,
        userName =
            store.state.config?.fullName ?? store.state.loginState.userName,
        userIcon = store.state.config?.imgSource,
        splash = !store.state.loginState.loggedIn,
        refresh = (() => store.dispatch(RefreshAction())),
        refreshNoInternet = (() => store.dispatch(RefreshNoInternetAction()));
  @override
  String toString() {
    return "HomePageContentViewModel(noInternet: $noInternet, hasDays: $hasDays, loading: $loading)";
  }
}
