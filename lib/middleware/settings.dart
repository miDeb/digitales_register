part of 'middleware.dart';

final _settingsMiddleware =
    MiddlewareBuilder<AppState, AppStateBuilder, AppActions>()
      ..add(GradesActionsNames.loaded, _updateSubjectThemes)
      ..add(DashboardActionsNames.loaded, _updateSubjectThemes)
      ..add(CalendarActionsNames.loaded, _updateSubjectThemes);

Future<void> _updateSubjectThemes(
    MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next,
    Action action) async {
  await next(action);
  final allSubjects = api.state.extractAllSubjects();
  await api.actions.settingsActions.updateSubjectThemes(allSubjects);
}
