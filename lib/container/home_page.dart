import 'package:dr/actions.dart';
import 'package:dr/app_state.dart';
import 'package:dr/ui/home_page_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, HomePageContentViewModel>(
      builder: (context, vm) {
        return HomePageContent(vm: vm);
      },
      distinct: true,
      converter: (store) {
        return HomePageContentViewModel.from(store);
      },
    );
  }
}

class HomePageContentViewModel {
  final bool noInternet, hasDays, loading, splash;
  final VoidCallback refresh, reload;
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
        reload = (() => store.dispatch(LoadAction()));

  operator ==(other) {
    return other is HomePageContentViewModel &&
        other.noInternet == noInternet &&
        other.hasDays == hasDays &&
        other.loading == loading &&
        other.splash == splash &&
        other.userName == userName &&
        other.userIcon == userIcon;
  }
}
