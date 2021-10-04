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

import 'package:built_collection/built_collection.dart';
import 'package:built_redux/built_redux.dart';
import 'package:dr/actions/messages_actions.dart';

import '../actions/notifications_actions.dart';
import '../app_state.dart';
import '../data.dart';
import '../util.dart';

final notificationsReducerBuilder = NestedReducerBuilder<AppState,
    AppStateBuilder, NotificationState, NotificationStateBuilder>(
  (s) => s.notificationState,
  (b) => b.notificationState,
)
  ..add(NotificationsActionsNames.loaded, _loaded)
  ..add(NotificationsActionsNames.delete, _delete)
  ..add(NotificationsActionsNames.deleteAll, _deleteAll)
  ..add(MessagesActionsNames.markAsRead, _markMessageAsRead);

void _loaded(NotificationState state, Action<List> action,
    NotificationStateBuilder builder) {
  builder.notifications = tryParse(action.payload, _parseNotifications);
}

ListBuilder<Notification> _parseNotifications(List data) {
  return ListBuilder(
    data.map<Notification>(
      (dynamic n) => tryParse(
        getMap(n),
        (dynamic n) => Notification(
          (b) => b
            ..id = getInt(n["id"])
            ..title = getString(n["title"])
            ..type = getString(n["type"])
            ..objectId = getInt(n["objectId"])
            ..subTitle = getString(n["subTitle"])
            ..timeSent = DateTime.parse(getString(n["timeSent"])!),
        ),
      ),
    ),
  );
}

void _markMessageAsRead(NotificationState state, Action<int> action,
    NotificationStateBuilder builder) {
  builder.notifications.removeWhere((n) => n.objectId == action.payload);
}

void _delete(NotificationState state, Action<Notification> action,
    NotificationStateBuilder builder) {
  builder.notifications.remove(action.payload);
}

void _deleteAll(NotificationState state, Action<void> action,
    NotificationStateBuilder builder) {
  builder.notifications.removeWhere((n) => n.type != "message");
}
