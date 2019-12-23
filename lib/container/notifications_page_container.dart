import 'package:flutter/material.dart' hide Notification;
import 'package:flutter_built_redux/flutter_built_redux.dart';

import '../actions/app_actions.dart';
import '../app_state.dart';
import '../data.dart';
import '../ui/notifications_page.dart';

class NotificationPageContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnection<AppState, AppActions, List<Notification>>(
      builder: (context, vm, actions) {
        return NotificationPage(
          notifications: vm,
          deleteNotification: actions.notificationsActions.delete,
          deleteAllNotifications: actions.notificationsActions.deleteAll,
        );
      },
      connect: (state) {
        return state.notificationState.notifications.toList();
      },
    );
  }
}
