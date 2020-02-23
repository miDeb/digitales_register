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
  if (api.state.noInternet) return;

  next(action);
  final data = await _wrapper.send("/api/notification/unread");

  if (data != null) {
    api.actions.notificationsActions.loaded(data);
  } else {
    api.actions.refreshNoInternet();
  }
}

void _deleteNotification(
    MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next,
    Action<Notification> action) async {
  next(action);
  final result = await _wrapper.send("/api/notification/markAsRead",
      args: {"id": action.payload.id}, json: false);
  if (result == null) api.actions.refreshNoInternet();
}

void _deleteAllNotifications(
    MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next,
    Action<void> action) async {
  next(action);
  final result = await _wrapper.send("/api/notification/markAsRead",
      args: {}, json: false);
  if (result == null) api.actions.refreshNoInternet();
}
