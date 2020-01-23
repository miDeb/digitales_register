import 'package:flutter/material.dart' hide Notification;
import 'package:flutter_built_redux/flutter_built_redux.dart';
import 'package:tuple/tuple.dart';

import '../actions/app_actions.dart';
import '../app_state.dart';
import '../data.dart';
import '../ui/notifications_page.dart';

class NotificationPageContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnection<AppState, AppActions, Tuple2<List<Notification>, bool>>(
      builder: (context, vm, actions) {
        return NotificationPage(
          notifications: vm.item1,
          noInternet: vm.item2,
          deleteNotification: actions.notificationsActions.delete,
          deleteAllNotifications: actions.notificationsActions.deleteAll,
        );
      },
      connect: (state) {
        return Tuple2(state.notificationState.notifications.toList(), state.noInternet);
      },
    );
  }
}
