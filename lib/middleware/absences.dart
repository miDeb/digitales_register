part of 'middleware.dart';

final _absencesMiddleware = MiddlewareBuilder<AppState, AppStateBuilder, AppActions>()
  ..add(AbsencesActionsNames.load, _loadAbsences);

void _loadAbsences(MiddlewareApi<AppState, AppStateBuilder, AppActions> api, ActionHandler next,
    Action<void> action) async {
  if (api.state.noInternet) return;
  next(action);
  final response = await _wrapper.send("/api/student/dashboard/absences");
  if (response != null) {
    api.actions.absencesActions.loaded(response);
  } else {
    api.actions.refreshNoInternet();
  }
}
