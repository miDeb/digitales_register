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

import 'package:dr/actions/app_actions.dart';
import 'package:dr/app_state.dart';
import 'package:dr/data.dart';
import 'package:dr/ui/notifications_page.dart';
import 'package:dr/utc_date_time.dart';
import 'package:flutter/material.dart' hide Notification;
import 'package:flutter_built_redux/flutter_built_redux.dart';
import 'package:tuple/tuple.dart';

class NotificationPageContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnection<AppState, AppActions,
        Tuple3<List<Notification>, UtcDateTime?, bool>>(
      builder: (context, vm, actions) {
        return NotificationPage(
          notifications: vm.item1,
          noInternet: vm.item3,
          deleteNotification: actions.notificationsActions.delete,
          deleteAllNotifications: actions.notificationsActions.deleteAll,
          goToMessage: actions.routingActions.showMessage,
          lastFetched: vm.item2,
        );
      },
      connect: (state) {
        return Tuple3(
          state.notificationState.notifications!.toList(),
          state.notificationState.lastFetched,
          state.noInternet,
        );
      },
    );
  }
}
