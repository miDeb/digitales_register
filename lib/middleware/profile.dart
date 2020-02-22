part of 'middleware.dart';

final _profileMiddleware = MiddlewareBuilder<AppState, AppStateBuilder,
    AppActions>()
  ..add(ProfileActionsNames.load, _loadProfile)
  ..add(ProfileActionsNames.sendNotificationEmails, _setSendNotificationEmails)
  ..add(ProfileActionsNames.changeEmail, _changeEmail);

void _loadProfile(MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next, Action<void> action) async {
  next(action);
  if (api.state.noInternet) return;
  final result = await _wrapper.send("/api/profile/get");
  api.actions.profileActions.loaded(result);
}

void _setSendNotificationEmails(
    MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next,
    Action<bool> action) {
  next(action);
  _wrapper.send(
    "/api/profile/updateNotificationSettings",
    args: {
      "notificationsEnabled": action.payload,
    },
    json: false,
  );
}

void _changeEmail(MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next, Action<ChangeEmailPayload> action) async {
  next(action);
  final result = await _wrapper.send(
    "/api/profile/updateProfile",
    args: {
      "email": action.payload.email,
      "password": action.payload.pass,
    },
  );
  if (result["error"] == null) {
    showToast(msg: result["message"]);
    navigatorKey.currentState.pop();
  } else {
    showToast(msg: "[${result["error"]}]: ${result["message"]}");
  }
  api.actions.profileActions.load();
}
