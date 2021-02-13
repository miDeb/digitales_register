part of 'middleware.dart';

enum Pages {
  homework,
  grades,
  absences,
  calendar,
  certificate,
  messages,
  settings,
}

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
      ..add(RoutingActionsNames.showEditGradesAverageSettings,
          _showEditGradesAverageSettings)
      ..add(RoutingActionsNames.showCalendar, _showCalendar)
      ..add(RoutingActionsNames.showAbsences, _showAbsences)
      ..add(RoutingActionsNames.showGradesChart, _showGradesChart)
      ..add(RoutingActionsNames.showGrades, _showGrades)
      ..add(RoutingActionsNames.showGradeCalculator, _showGradeCalculator)
      ..add(RoutingActionsNames.showCertificate, _showCertificate)
      ..add(RoutingActionsNames.showMessages, _showMessages)
      ..add(RoutingActionsNames.showMessage, _showMessage);

Future<void> _showLogin(
    MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next,
    Action<void> action) async {
  await next(action);
  // hack since the current route is not exposed otherwise
  Route? currentRoute;
  navigatorKey?.currentState?.popUntil((route) {
    currentRoute = route;
    // by returning true here no route is actually popped.
    return true;
  });

  if (currentRoute?.settings.name != "/login") {
    navigatorKey?.currentState?.pushNamed("/login");
  }
}

Future<void> _showRequestPassReset(
    MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next,
    Action<void> action) async {
  navigatorKey?.currentState?.pushNamed("/request_pass_reset");
  await next(action);
}

Future<void> _showPassReset(
    MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next,
    Action<void> action) async {
  navigatorKey?.currentState?.pushNamed("/pass_reset");
  await next(action);
}

Future<void> _showChangeEmail(
    MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next,
    Action<void> action) async {
  navigatorKey?.currentState?.pushNamed("/change_email");
  await next(action);
}

Future<void> _showProfile(
    MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next,
    Action<void> action) async {
  navigatorKey?.currentState?.pushNamed("/profile");
  api.actions.profileActions.load();
  await next(action);
}

Future<void> _showNotifications(
    MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next,
    Action<void> action) async {
  navigatorKey?.currentState?.pushNamed("/notifications");
  await next(action);
}

Future<void> _showSettings(
    MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next,
    Action<void> action) async {
  scaffoldKey?.currentState
      ?.selectContentWidget(SettingsPageContainer(), Pages.settings);
  await next(action);
}

Future<void> _showEditCalendarSubjectNicks(
    MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next,
    Action<void> action) async {
  navigatorKey?.currentState?.pushNamed("/settings");
  await next(action);
}

Future<void> _showEditGradesAverageSettings(
    MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next,
    Action<void> action) async {
  navigatorKey?.currentState?.pushNamed("/settings");
  await next(action);
}

Future<void> _showCalendar(
    MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next,
    Action<void> action) async {
  scaffoldKey?.currentState
      ?.selectContentWidget(CalendarContainer(), Pages.calendar);
  api.actions.calendarActions.setCurrentMonday(toMonday(now));

  await next(action);
}

Future<void> _showGrades(
    MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next,
    Action<void> action) async {
  scaffoldKey?.currentState
      ?.selectContentWidget(GradesPageContainer(), Pages.grades);
  api.actions.gradesActions.load(api.state.gradesState.semester);
  await next(action);
}

Future<void> _showAbsences(
    MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next,
    Action<void> action) async {
  scaffoldKey?.currentState
      ?.selectContentWidget(AbsencesPageContainer(), Pages.absences);
  api.actions.absencesActions.load();
  await next(action);
}

Future<void> _showCertificate(
    MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next,
    Action<void> action) async {
  scaffoldKey?.currentState
      ?.selectContentWidget(CertificateContainer(), Pages.certificate);
  api.actions.certificateActions.load();
  await next(action);
}

Future<void> _showMessages(
    MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next,
    Action<void> action) async {
  scaffoldKey?.currentState
      ?.selectContentWidget(MessagesPageContainer(), Pages.messages);
  api.actions.messagesActions.load();
  await next(action);
}

Future<void> _showMessage(
    MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next,
    Action<int> action) async {
  navigatorKey?.currentState?.pop();
  api.actions.routingActions.showMessages();
  await next(action);
}

Future<void> _showGradesChart(
    MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next,
    Action<void> action) async {
  navigatorKey?.currentState?.pushNamed("/gradesChart");
  await next(action);
}

Future<void> _showGradeCalculator(
    MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next,
    Action<void> action) async {
  navigatorKey?.currentState?.pushNamed("/gradeCalculator");
  api.actions.gradesActions.load(Semester.all);
  await next(action);
}
