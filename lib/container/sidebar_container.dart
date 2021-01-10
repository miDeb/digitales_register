import 'package:built_value/built_value.dart';
import 'package:dr/actions/app_actions.dart';
import 'package:dr/actions/login_actions.dart';
import 'package:dr/middleware/middleware.dart';
import 'package:dr/ui/sidebar.dart';
import 'package:flutter/material.dart' hide Builder;
import 'package:flutter_built_redux/flutter_built_redux.dart';

import '../app_state.dart';

part 'sidebar_container.g.dart';

class SidebarContainer extends StatelessWidget {
  final bool tabletMode;
  final VoidCallback goHome;
  final Pages currentSelected;

  const SidebarContainer(
      {Key key, this.tabletMode, this.goHome, this.currentSelected})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StoreConnection<AppState, AppActions, SidebarViewModel>(
      builder: (BuildContext context, state, AppActions actions) {
        return Sidebar(
          currentSelected: currentSelected,
          drawerInitiallyFullyExpanded: state.drawerInitiallyFullyExpanded,
          goHome: goHome,
          onDrawerExpansionChange: actions.settingsActions.drawerExpandedChange,
          tabletMode: tabletMode,
          userIcon: state.userIcon,
          username: state.username,
          showAbsences: actions.routingActions.showAbsences,
          showCalendar: actions.routingActions.showCalendar,
          showCertificate: actions.routingActions.showCertificate,
          showGrades: actions.routingActions.showGrades,
          showMessages: actions.routingActions.showMessages,
          showSettings: actions.routingActions.showSettings,
          logout: () => actions.loginActions.logout(
            LogoutPayload(
              (b) => b
                ..hard = true
                ..forced = false,
            ),
          ),
        );
      },
      connect: (AppState state) {
        return SidebarViewModel(
          (b) => b
            ..username = state.config?.fullName ?? state.loginState.username
            ..userIcon = state.config?.imgSource
            ..drawerInitiallyFullyExpanded =
                state.settingsState.drawerFullyExpanded,
        );
      },
    );
  }
}

abstract class SidebarViewModel
    implements Built<SidebarViewModel, SidebarViewModelBuilder> {
  @nullable
  String get username;
  @nullable
  String get userIcon;
  bool get drawerInitiallyFullyExpanded;
  SidebarViewModel._();

  factory SidebarViewModel([void Function(SidebarViewModelBuilder) updates]) =
      _$SidebarViewModel;
}
