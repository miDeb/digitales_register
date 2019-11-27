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
  final bool noInternet, loading, splash;
  final VoidCallback  refreshNoInternet;
  final String userName, userIcon;
  HomePageContentViewModel.from(Store<AppState> store)
      : noInternet = store.state.noInternet,
        loading = store.state.dayState.loading,
        userName =
            store.state.config?.fullName ?? store.state.loginState.userName,
        userIcon = store.state.config?.imgSource,
        splash = !store.state.loginState.loggedIn,
        refreshNoInternet = (() => store.dispatch(RefreshNoInternetAction()));
  @override
  String toString() {
    return "HomePageContentViewModel(noInternet: $noInternet, loading: $loading)";
  }
}
