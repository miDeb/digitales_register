import 'package:built_collection/built_collection.dart';
import 'package:redux/redux.dart';

import '../actions.dart';
import '../app_state.dart';

final notificationsReducer = combineReducers<NotificationStateBuilder>([
  _createNotificationsLoadedReducer(),
  _createDeleteNotificationReducer(),
  _createDeleteAllNotificationsReducer(),
]);
TypedReducer<NotificationStateBuilder, NotificationsLoadedAction>
    _createNotificationsLoadedReducer() {
  return TypedReducer(
      (NotificationStateBuilder state, NotificationsLoadedAction action) {
    return state..notifications = ListBuilder(action.notifications);
  });
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
