import 'package:built_value/built_value.dart';

import '../data.dart';

part 'notifications_actions.g.dart';

abstract class LoadNotificationsAction
    implements Built<LoadNotificationsAction, LoadNotificationsActionBuilder> {
  LoadNotificationsAction._();
  factory LoadNotificationsAction(
          [void Function(LoadNotificationsActionBuilder) updates]) =
      _$LoadNotificationsAction;
}

abstract class NotificationsLoadedAction
    implements
        Built<NotificationsLoadedAction, NotificationsLoadedActionBuilder> {
  NotificationsLoadedAction._();
  factory NotificationsLoadedAction(
          [void Function(NotificationsLoadedActionBuilder) updates]) =
      _$NotificationsLoadedAction;

  Object get data;
}

abstract class DeleteNotificationAction
    implements
        Built<DeleteNotificationAction, DeleteNotificationActionBuilder> {
  DeleteNotificationAction._();
  factory DeleteNotificationAction(
          [void Function(DeleteNotificationActionBuilder) updates]) =
      _$DeleteNotificationAction;

  Notification get notification;
}

abstract class DeleteAllNotificationsAction
    implements
        Built<DeleteAllNotificationsAction,
            DeleteAllNotificationsActionBuilder> {
  DeleteAllNotificationsAction._();
  factory DeleteAllNotificationsAction(
          [void Function(DeleteAllNotificationsActionBuilder) updates]) =
      _$DeleteAllNotificationsAction;
}
