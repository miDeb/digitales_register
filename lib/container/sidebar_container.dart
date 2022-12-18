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
import 'package:dr/actions/app_actions.dart';
import 'package:dr/actions/login_actions.dart';
import 'package:dr/app_state.dart';
import 'package:dr/middleware/middleware.dart';
import 'package:dr/ui/sidebar.dart';
import 'package:flutter/material.dart' hide Builder;
import 'package:flutter_built_redux/flutter_built_redux.dart';

part 'sidebar_container.g.dart';

class SidebarContainer extends StatelessWidget {
  final bool tabletMode;
  final VoidCallback goHome;
  final Pages currentSelected;

  const SidebarContainer(
      {super.key,
      required this.tabletMode,
      required this.goHome,
      required this.currentSelected});
  @override
  Widget build(BuildContext context) {
    return StoreConnection<AppState, AppActions, SidebarViewModel>(
      builder: (BuildContext context, state, AppActions actions) {
        return Sidebar(
          currentSelected: currentSelected,
          drawerExpanded: state.drawerInitiallyFullyExpanded,
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
          otherAccounts: state.otherAccounts.toList(),
          selectAccount: actions.loginActions.selectAccount,
          addAccount: actions.loginActions.addAccount,
          logout: () => actions.loginActions.logout(
            LogoutPayload(
              (b) => b
                ..hard = true
                ..forced = false,
            ),
          ),
          passwordSavingEnabled: state.passwordSavingEnabled,
        );
      },
      connect: (AppState state) {
        return SidebarViewModel(
          (b) => b
            ..username = state.config?.fullName ?? state.loginState.username
            ..userIcon = state.config?.imgSource
            ..drawerInitiallyFullyExpanded =
                state.settingsState.drawerFullyExpanded
            ..otherAccounts = state.loginState.otherAccounts.toBuilder()
            ..passwordSavingEnabled = !state.settingsState.noPasswordSaving,
        );
      },
    );
  }
}

abstract class SidebarViewModel
    implements Built<SidebarViewModel, SidebarViewModelBuilder> {
  String? get username;

  String? get userIcon;
  bool get drawerInitiallyFullyExpanded;
  bool get passwordSavingEnabled;
  BuiltList<String> get otherAccounts;

  factory SidebarViewModel([void Function(SidebarViewModelBuilder)? updates]) =
      _$SidebarViewModel;
  SidebarViewModel._();
}
