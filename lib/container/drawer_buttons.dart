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
          onShowSettings:
              actions.routingActions.showSettings,
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
            onShowAbsences:
                actions.routingActions.showAbsences);
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
          onShowCalendar:
              actions.routingActions.showCalendar,
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
          onShowCertificate:
              actions.routingActions.showCertificate,
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
          onShowMessages:
              actions.routingActions.showMessages,
        );
      },
    );
  }
}
