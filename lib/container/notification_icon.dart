import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../actions.dart';
import '../app_state.dart';
import '../ui/notification_icon_widget.dart';

class NotificationIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, NotificationIconViewModel>(
      builder: (BuildContext context, NotificationIconViewModel vm) {
        return NotificationIconWidget(vm: vm,);
      },
      converter: (store) {
        return NotificationIconViewModel(
            store.state.notificationState.notifications?.length ?? 0,
            () => store.dispatch(ShowNotificationsAction()));
      },
    );
  }
}

class NotificationIconViewModel {
  final int notifications;
  final VoidCallback onTap;

  NotificationIconViewModel(this.notifications, this.onTap);
}
