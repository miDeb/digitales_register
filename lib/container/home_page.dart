import 'package:built_value/built_value.dart';
import 'package:dr/actions/login_actions.dart';
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
          refreshNoInternet: actions.refreshNoInternet,
          showAbsences: actions.routingActions.showAbsences,
          showCalendar: actions.routingActions.showCalendar,
          showCertificate: actions.routingActions.showCertificate,
          showGrades: actions.routingActions.showGrades,
          showMessages: actions.routingActions.showMessages,
          showSettings: actions.routingActions.showSettings,
          onDrawerExpansionChange: actions.settingsActions.drawerExpandedChange,
          logout: () => actions.loginActions.logout(
            LogoutPayload(
              (b) => b
                ..hard = true
                ..forced = false,
            ),
          ),
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
  @nullable
  String get username;
  @nullable
  String get userIcon;
  bool get noInternet;
  bool get loading;
  bool get splash;
  bool get drawerInitiallyFullyExpanded;

  factory HomePageContentViewModel.from(AppState state) {
    return HomePageContentViewModel((b) => b
      ..noInternet = state.noInternet
      ..loading = state.dashboardState.loading
      ..username = state.config?.fullName ?? state.loginState.username
      ..userIcon = state.config?.imgSource
      ..splash = !state.loginState.loggedIn
      ..drawerInitiallyFullyExpanded = state.settingsState.drawerFullyExpanded);
  }

  HomePageContentViewModel._();
  factory HomePageContentViewModel(
          [void Function(HomePageContentViewModelBuilder) updates]) =
      _$HomePageContentViewModel;
}
