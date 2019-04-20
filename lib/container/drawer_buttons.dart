import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../actions.dart';
import '../app_state.dart';
import '../ui/drawer_buttons_widgets.dart';

class LogoutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, LogoutButtonViewModel>(
      converter: (Store store) {
        return LogoutButtonViewModel.from(store);
      },
      builder: (BuildContext context, LogoutButtonViewModel vm) {
        return LogoutButtonWidget(vm: vm);
      },
    );
  }
}

class LogoutButtonViewModel {
  final VoidCallback onLogout;

  LogoutButtonViewModel.from(Store store)
      : onLogout = store.state.loginState.loggedIn
            ? (() {
                store.dispatch(LogoutAction(true, false));
              })
            : null;
}

class SettingsButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, SettingsButtonViewModel>(
      converter: (Store store) {
        return SettingsButtonViewModel.from(store);
      },
      builder: (BuildContext context, SettingsButtonViewModel vm) {
        return SettingsButtonWidget(vm: vm);
      },
    );
  }
}

class SettingsButtonViewModel {
  final VoidCallback onShowSettings;

  SettingsButtonViewModel.from(Store<AppState> store)
      : onShowSettings = store.state.loginState.loggedIn
            ? (() {
                store.dispatch(ShowSettingsAction());
              })
            : null;
}

class GradesButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, GradesButtonViewModel>(
      converter: (Store store) {
        return GradesButtonViewModel.from(store);
      },
      builder: (BuildContext context, GradesButtonViewModel vm) {
        return GradesButtonWidget(vm: vm);
      },
    );
  }
}

class GradesButtonViewModel {
  final VoidCallback onShowGrades;

  GradesButtonViewModel.from(Store<AppState> store)
      : onShowGrades = store.state.config != null ||
                store.state.gradesState.subjects.isNotEmpty
            ? (() {
                store.dispatch(ShowGradesAction());
              })
            : null;
}

class AbsencesButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AbsencesButtonViewModel>(
      converter: (Store store) {
        return AbsencesButtonViewModel.from(store);
      },
      builder: (BuildContext context, AbsencesButtonViewModel vm) {
        return AbsencesButtonWidget(vm: vm);
      },
    );
  }
}

class AbsencesButtonViewModel {
  final VoidCallback onShowAbsences;

  AbsencesButtonViewModel.from(Store<AppState> store)
      : onShowAbsences = (() {
          store.dispatch(ShowAbsencesAction());
        });
}
class CalendarButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CalendarButtonViewModel>(
      converter: (Store store) {
        return CalendarButtonViewModel.from(store);
      },
      builder: (BuildContext context, CalendarButtonViewModel vm) {
        return CalendarButtonWidget(vm: vm);
      },
    );
  }
}

class CalendarButtonViewModel {
  final VoidCallback onShowCalendar;

  CalendarButtonViewModel.from(Store<AppState> store)
      : onShowCalendar = (() {
          store.dispatch(ShowCalendarAction());
        });
}
