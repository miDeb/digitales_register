// Copyright (C) 2021 Michael Debertol
//
// This file is part of digitales_register.
//
// digitales_register is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// digitales_register is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with digitales_register.  If not, see <http://www.gnu.org/licenses/>.

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
