part of 'middleware.dart';

final _routingMiddleware =
    MiddlewareBuilder<AppState, AppStateBuilder, AppActions>()
      ..add(RoutingActionsNames.showLogin, _showLogin)
      ..add(RoutingActionsNames.showRequestPassReset, _showRequestPassReset)
      ..add(RoutingActionsNames.showPassReset, _showPassReset)
      ..add(RoutingActionsNames.showChangeEmail, _showChangeEmail)
      ..add(RoutingActionsNames.showProfile, _showProfile)
      ..add(RoutingActionsNames.showNotifications, _showNotifications)
      ..add(RoutingActionsNames.showSettings, _showSettings)
      ..add(RoutingActionsNames.showEditCalendarSubjectNicks,
          _showEditCalendarSubjectNicks)
      ..add(RoutingActionsNames.showCalendar, _showCalendar)
      ..add(RoutingActionsNames.showAbsences, _showAbsences)
      ..add(RoutingActionsNames.showGradesChart, _showGradesChart)
      ..add(RoutingActionsNames.showGrades, _showGrades)
      ..add(RoutingActionsNames.showCertificate, _showCertificate)
      ..add(RoutingActionsNames.showMessages, _showMessages);

void _showLogin(MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next, Action<void> action) async {
  next(action);
  // hack since the current route is not exposed otherwise
  Route currentRoute;
  navigatorKey.currentState?.popUntil((route) {
    currentRoute = route;
    return true;
  });
  if (currentRoute?.settings?.name != "/login") {
    navigatorKey.currentState?.pushNamed("/login");
  }
}

void _showRequestPassReset(
    MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next,
    Action<void> action) {
  navigatorKey.currentState.pushNamed("/request_pass_reset");
  next(action);
}

void _showPassReset(MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next, Action<void> action) {
  navigatorKey.currentState.pushNamed("/pass_reset");
  next(action);
}

void _showChangeEmail(MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next, Action<void> action) {
  navigatorKey.currentState.pushNamed("/change_email");
  next(action);
}

void _showProfile(MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next, Action<void> action) {
  navigatorKey.currentState.pushNamed("/profile");
  api.actions.profileActions.load();
  next(action);
}

void _showNotifications(
    MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next,
    Action<void> action) {
  navigatorKey.currentState.pushNamed("/notifications");
  next(action);
}

void _showSettings(MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next, Action<void> action) {
  navigatorKey.currentState.pushNamed("/settings");
  next(action);
}

void _showEditCalendarSubjectNicks(
    MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next,
    Action<void> action) {
  navigatorKey.currentState.pushNamed("/settings");
  next(action);
}

void _showCalendar(MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next, Action<void> action) {
  navigatorKey.currentState.pushNamed("/calendar");
  api.actions.calendarActions.setCurrentMonday(toMonday(now));

  next(action);
}

void _showGrades(MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next, Action<void> action) {
  navigatorKey.currentState.pushNamed("/grades");
  api.actions.gradesActions.load(api.state.gradesState.semester);
  next(action);
}

void _showAbsences(MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next, Action<void> action) {
  navigatorKey.currentState.pushNamed("/absences");
  api.actions.absencesActions.load();
  next(action);
}

void _showCertificate(MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next, Action<void> action) {
  navigatorKey.currentState.pushNamed("/certificate");
  api.actions.certificateActions.load();
  next(action);
}

void _showMessages(MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next, Action<void> action) {
  navigatorKey.currentState.pushNamed("/messages");
  api.actions.messagesActions.load();
  next(action);
}

void _showGradesChart(MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next, Action<void> action) {
  navigatorKey.currentState.pushNamed("/gradesChart");
  next(action);
}
