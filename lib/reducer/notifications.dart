import 'package:built_collection/built_collection.dart';
import 'package:redux/redux.dart';

import '../actions/notifications_actions.dart';
import '../app_state.dart';
import '../data.dart';

final notificationsReducer = combineReducers<NotificationStateBuilder>([
  _createNotificationsLoadedReducer(),
  _createDeleteNotificationReducer(),
  _createDeleteAllNotificationsReducer(),
]);
TypedReducer<NotificationStateBuilder, NotificationsLoadedAction>
    _createNotificationsLoadedReducer() {
  return TypedReducer(
      (NotificationStateBuilder state, NotificationsLoadedAction action) {
    return state..notifications = _parseNotifications(action.data);
  });
}

ListBuilder<Notification> _parseNotifications(data) {
  return ListBuilder(
    data.map(
      (n) => Notification(
        (b) => b
          ..id = n["id"]
          ..title = n["title"]
          ..subTitle = n["subTitle"]
          ..timeSent = DateTime.parse(
            n["timeSent"],
          ),
      ),
    ),
  );
}

TypedReducer<NotificationStateBuilder, DeleteNotificationAction>
    _createDeleteNotificationReducer() {
  return TypedReducer(
      (NotificationStateBuilder state, DeleteNotificationAction action) {
    return state..notifications.remove(action.notification);
  });
}

TypedReducer<NotificationStateBuilder, DeleteAllNotificationsAction>
    _createDeleteAllNotificationsReducer() {
  return TypedReducer(
      (NotificationStateBuilder state, DeleteAllNotificationsAction action) {
    return state..notifications.clear();
  });
}
