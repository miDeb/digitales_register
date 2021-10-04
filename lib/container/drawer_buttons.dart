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

import 'package:flutter/material.dart';
import 'package:flutter_built_redux/flutter_built_redux.dart';

import '../actions/app_actions.dart';
import '../actions/login_actions.dart';
import '../app_state.dart';
import '../ui/drawer_buttons_widgets.dart';

class LogoutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnection<AppState, AppActions, void>(
      connect: (state) {},
      builder: (context, vm, actions) {
        return LogoutButtonWidget(
          onLogout: () => actions.loginActions.logout(
            LogoutPayload(
              (b) => b
                ..hard = true
                ..forced = false,
            ),
          ),
        );
      },
    );
  }
}

class SettingsButton extends StatelessWidget {
  final bool selected;

  const SettingsButton({Key? key, required this.selected}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StoreConnection<AppState, AppActions, void>(
      connect: (state) {},
      builder: (context, vm, actions) {
        return SettingsButtonWidget(
          selected: selected,
          onShowSettings: actions.routingActions.showSettings,
        );
      },
    );
  }
}

class GradesButton extends StatelessWidget {
  final bool selected;

  const GradesButton({Key? key, required this.selected}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StoreConnection<AppState, AppActions, void>(
      connect: (state) {},
      builder: (context, vm, actions) {
        return GradesButtonWidget(
          selected: selected,
          onShowGrades: actions.routingActions.showGrades,
        );
      },
    );
  }
}

class AbsencesButton extends StatelessWidget {
  final bool selected;

  const AbsencesButton({Key? key, required this.selected}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StoreConnection<AppState, AppActions, void>(
      connect: (state) {},
      builder: (context, vm, actions) {
        return AbsencesButtonWidget(
            selected: selected,
            onShowAbsences: actions.routingActions.showAbsences);
      },
    );
  }
}

class CalendarButton extends StatelessWidget {
  final bool selected;

  const CalendarButton({Key? key, required this.selected}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StoreConnection<AppState, AppActions, void>(
      connect: (state) {},
      builder: (context, vm, actions) {
        return CalendarButtonWidget(
          selected: selected,
          onShowCalendar: actions.routingActions.showCalendar,
        );
      },
    );
  }
}

class CertificateButton extends StatelessWidget {
  final bool selected;

  const CertificateButton({Key? key, required this.selected}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StoreConnection<AppState, AppActions, void>(
      connect: (state) {},
      builder: (context, vm, actions) {
        return CertificateButtonWidget(
          selected: selected,
          onShowCertificate: actions.routingActions.showCertificate,
        );
      },
    );
  }
}

class MessagesButton extends StatelessWidget {
  final bool selected;

  const MessagesButton({Key? key, required this.selected}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StoreConnection<AppState, AppActions, void>(
      connect: (state) {},
      builder: (context, vm, actions) {
        return MessagesButtonWidget(
          selected: selected,
          onShowMessages: actions.routingActions.showMessages,
        );
      },
    );
  }
}
