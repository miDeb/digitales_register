part of 'middleware.dart';

final _absencesMiddleware =
    MiddlewareBuilder<AppState, AppStateBuilder, AppActions>()
      ..add(AbsencesActionsNames.load, _loadAbsences);

void _loadAbsences(MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next, Action<void> action) async {
  next(action);
  if (await _wrapper.noInternet) {
    api.actions.noInternet(true);
    return;
  }
  final response = await _wrapper.post("/api/student/dashboard/absences");
  if (response != null) {
    api.actions.absencesActions.loaded(response);
  }
}
