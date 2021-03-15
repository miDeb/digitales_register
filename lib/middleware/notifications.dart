part of 'middleware.dart';

final _notificationsMiddleware =
    MiddlewareBuilder<AppState, AppStateBuilder, AppActions>()
      ..add(NotificationsActionsNames.load, _loadNotifications)
      ..add(NotificationsActionsNames.delete, _deleteNotification)
      ..add(NotificationsActionsNames.deleteAll, _deleteAllNotifications);

Future<void> _loadNotifications(
    MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next,
    Action<void> action) async {
  if (api.state.noInternet) return;

  await next(action);
  final dynamic data = await wrapper.send("api/notification/unread");

  if (data != null) {
    api.actions.notificationsActions.loaded(data as List);
  } else {
    api.actions.refreshNoInternet();
  }
}

Future<void> _deleteNotification(
    MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next,
    Action<Notification> action) async {
  await next(action);
  final dynamic result = await wrapper.send(
    "api/notification/markAsRead",
    args: {"id": action.payload.id},
  );
  if (result == null) api.actions.refreshNoInternet();
}

Future<void> _deleteAllNotifications(
    MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next,
    Action<void> action) async {
  await next(action);
  for (final n in api.state.notificationState.notifications!
      .where((n) => n.type == "message" && n.objectId != null)) {
    api.actions.messagesActions.markAsRead(n.objectId!);
  }
  final result = wrapper.send(
    "api/notification/markAsRead",
    args: {},
  );
  if (await result == null) api.actions.refreshNoInternet();
}
