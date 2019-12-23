part of 'middleware.dart';

final _notificationsMiddleware =
    MiddlewareBuilder<AppState, AppStateBuilder, AppActions>()
      ..add(NotificationsActionsNames.load, _loadNotifications)
      ..add(NotificationsActionsNames.delete, _deleteNotification)
      ..add(NotificationsActionsNames.deleteAll, _deleteAllNotifications);

void _loadNotifications(
    MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next,
    Action<void> action) async {
  next(action);
  final data = await _wrapper.post("/api/notification/unread");

  if (data != null) {
    api.actions.notificationsActions.loaded(data);
  }
}

void _deleteNotification(
    MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next,
    Action<Notification> action) async {
  next(action);

  _wrapper.post(
      "/api/notification/markAsRead", {"id": action.payload.id}, false);

  if (await _wrapper.noInternet) {
    api.actions.noInternet(true);
  }
}

void _deleteAllNotifications(
    MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next,
    Action<void> action) async {
  next(action);

  _wrapper.post("/api/notification/markAsRead", {}, false);

  if (await _wrapper.noInternet) {
    api.actions.noInternet(true);
  }
}
