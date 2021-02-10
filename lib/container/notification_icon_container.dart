import 'package:flutter/material.dart';
import 'package:flutter_built_redux/flutter_built_redux.dart';

import '../actions/app_actions.dart';
import '../app_state.dart';
import '../ui/notification_icon.dart';

class NotificationIconContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnection<AppState, AppActions, int>(
      builder: (context, vm, actions) {
        return NotificationIcon(
          notifications: vm,
          onTap: actions.routingActions.showNotifications ,
        );
      },
      connect: (state) {
        return state.notificationState.notifications?.length ?? 0;
      },
    );
  }
}
