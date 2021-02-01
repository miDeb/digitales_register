part of 'middleware.dart';

final _profileMiddleware = MiddlewareBuilder<AppState, AppStateBuilder,
    AppActions>()
  ..add(ProfileActionsNames.load, _loadProfile)
  ..add(ProfileActionsNames.sendNotificationEmails, _setSendNotificationEmails)
  ..add(ProfileActionsNames.changeEmail, _changeEmail);

Future<void> _loadProfile(
    MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next,
    Action<void> action) async {
  await next(action);
  if (api.state.noInternet) return;
  final result = await _wrapper.send("api/profile/get");
  if (result == null) {
    api.actions.refreshNoInternet();
    return;
  }
  api.actions.profileActions.loaded(result);
}

Future<void> _setSendNotificationEmails(
    MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next,
    Action<bool> action) async {
  await next(action);
  final result = await _wrapper.send(
    "api/profile/updateNotificationSettings",
    args: {
      "notificationsEnabled": action.payload,
    },
  );
  if (result == null) {
    api.actions.refreshNoInternet();
    return;
  }
}

Future<void> _changeEmail(
    MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next,
    Action<ChangeEmailPayload> action) async {
  await next(action);
  final result = await _wrapper.send(
    "api/profile/updateProfile",
    args: {
      "email": action.payload.email,
      "password": action.payload.pass,
    },
  );
  if (result == null) {
    api.actions.refreshNoInternet();
    return;
  }
  if (result["error"] == null) {
    showSnackBar(result["message"] as String);
    navigatorKey.currentState.pop();
  } else {
    showSnackBar("[${result["error"]}]: ${result["message"]}");
  }
  api.actions.profileActions.load();
}
