part of 'middleware.dart';

final _certificateMiddleware =
    MiddlewareBuilder<AppState, AppStateBuilder, AppActions>()
      ..add(CertificateActionsNames.load, _loadCertificate);

Future<void> _loadCertificate(
    MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next,
    Action<void> action) async {
  if (api.state.noInternet) return;
  next(action);
  final response = await _wrapper.send("student/certificate", method: "GET");
  if (response != null) {
    api.actions.certificateActions.loaded(response as String);
  } else {
    api.actions.refreshNoInternet();
  }
}
