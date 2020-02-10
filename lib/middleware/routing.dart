part of 'middleware.dart';

final _routingMiddleware = MiddlewareBuilder<AppState, AppStateBuilder, AppActions>()
  ..add(RoutingActionsNames.showLogin, _showLogin)
  ..add(RoutingActionsNames.showNotifications, _showNotifications)
  ..add(RoutingActionsNames.showSettings, _showSettings)
  ..add(RoutingActionsNames.showEditCalendarSubjectNicks, _showEditCalendarSubjectNicks)
  ..add(RoutingActionsNames.showCalendar, _showCalendar)
  ..add(RoutingActionsNames.showAbsences, _showAbsences)
  ..add(RoutingActionsNames.showGradesChart, _showGradesChart)
  ..add(RoutingActionsNames.showGrades, _showGrades)
  ..add(RoutingActionsNames.showCertificate, _showCertificate);

void _showLogin(MiddlewareApi<AppState, AppStateBuilder, AppActions> api, ActionHandler next,
    Action<void> action) async {
  next(action);
  if (api.state.currentRouteIsLogin) return;
  navigatorKey.currentState.pushNamed("/login");
  api.actions.isLoginRoute(true);
}

void _showNotifications(MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next, Action<void> action) {
  navigatorKey.currentState.pushNamed("/notifications");
  next(action);
}

void _showSettings(MiddlewareApi<AppState, AppStateBuilder, AppActions> api, ActionHandler next,
    Action<void> action) {
  navigatorKey.currentState.pushNamed("/settings");
  next(action);
}

void _showEditCalendarSubjectNicks(MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next, Action<void> action) {
  navigatorKey.currentState.pushNamed("/settings");
  next(action);
}

void _showCalendar(MiddlewareApi<AppState, AppStateBuilder, AppActions> api, ActionHandler next,
    Action<void> action) {
  navigatorKey.currentState.pushNamed("/calendar");
  api.actions.calendarActions.setCurrentMonday(toMonday(DateTime.now()));

  next(action);
}

void _showGrades(MiddlewareApi<AppState, AppStateBuilder, AppActions> api, ActionHandler next,
    Action<void> action) {
  navigatorKey.currentState.pushNamed("/grades");
  api.actions.gradesActions.load(api.state.gradesState.semester);
  next(action);
}

void _showAbsences(MiddlewareApi<AppState, AppStateBuilder, AppActions> api, ActionHandler next,
    Action<void> action) {
  navigatorKey.currentState.pushNamed("/absences");
  api.actions.absencesActions.load();
  next(action);
}

void _showCertificate(MiddlewareApi<AppState, AppStateBuilder, AppActions> api, ActionHandler next,
    Action<void> action) {
  navigatorKey.currentState.pushNamed("/certificate");
  api.actions.certificateActions.load();
  next(action);
}

void _showGradesChart(MiddlewareApi<AppState, AppStateBuilder, AppActions> api, ActionHandler next,
    Action<void> action) {
  navigatorKey.currentState.pushNamed("/gradesChart");
  next(action);
}
