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
  @override
  Widget build(BuildContext context) {
    return StoreConnection<AppState, AppActions, void>(
      connect: (state) {},
      builder: (context, vm, actions) {
        return SettingsButtonWidget(
          onShowSettings: actions.routingActions.showSettings,
        );
      },
    );
  }
}

class GradesButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnection<AppState, AppActions, void>(
      connect: (state) {},
      builder: (context, vm, actions) {
        return GradesButtonWidget(
          onShowGrades: actions.routingActions.showGrades,
        );
      },
    );
  }
}

class AbsencesButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnection<AppState, AppActions, void>(
      connect: (state) {},
      builder: (context, vm, actions) {
        return AbsencesButtonWidget(onShowAbsences: actions.routingActions.showAbsences);
      },
    );
  }
}

class CalendarButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnection<AppState, AppActions, void>(
      connect: (state) {},
      builder: (context, vm, actions) {
        return CalendarButtonWidget(
          onShowCalendar: actions.routingActions.showCalendar,
        );
      },
    );
  }
}
