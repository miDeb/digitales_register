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

import 'package:deleteable_tile/deleteable_tile.dart';
import 'package:dr/data.dart';
import 'package:dr/main.dart';
import 'package:dr/ui/last_fetched_overlay.dart';
import 'package:dr/utc_date_time.dart';
import 'package:dr/util.dart';
import 'package:flutter/material.dart' hide Notification;
import 'package:intl/intl.dart';

class NotificationPage extends StatelessWidget {
  final List<Notification> notifications;
  final SingleArgumentVoidCallback<Notification> deleteNotification;
  final SingleArgumentVoidCallback<int> goToMessage;
  final VoidCallback deleteAllNotifications;
  final bool noInternet;
  final UtcDateTime? lastFetched;

  const NotificationPage({
    super.key,
    required this.notifications,
    required this.deleteNotification,
    required this.deleteAllNotifications,
    required this.noInternet,
    required this.goToMessage,
    required this.lastFetched,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Benachrichtigungen"),
      ),
      body: LastFetchedOverlay(
        lastFetched: lastFetched,
        noInternet: noInternet,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: notifications.isEmpty
              ? Center(
                  child: Text(
                    "Keine Benachrichtigungen",
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                )
              : ListView.builder(
                  // For some reason the outgoing animation is not triggered if we don't add this key
                  key: const ValueKey("notifications list"),
                  itemCount: notifications.length + 1,
                  itemBuilder: (_, n) {
                    if (n == 0) {
                      return Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: noInternet ? null : deleteAllNotifications,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Text("Alle gelesen"),
                              SizedBox(width: 8),
                              Icon(Icons.done_all),
                            ],
                          ),
                        ),
                      );
                    }
                    n -= 1;
                    return NotificationWidget(
                      key: ObjectKey(notifications[n]),
                      notification: notifications[n],
                      onDelete: deleteNotification,
                      noInternet: noInternet,
                      goToMessage: goToMessage,
                      isLast: notifications.length == 1,
                    );
                  },
                ),
        ),
      ),
    );
  }
}

class NotificationWidget extends StatelessWidget {
  final Notification notification;
  final bool? noInternet;
  final SingleArgumentVoidCallback<Notification> onDelete;
  final SingleArgumentVoidCallback<int> goToMessage;
  final bool isLast;

  const NotificationWidget({
    super.key,
    required this.notification,
    required this.onDelete,
    required this.noInternet,
    required this.goToMessage,
    required this.isLast,
  });
  @override
  Widget build(BuildContext context) {
    return Deleteable(
      showEntryAnimation: false,
      showExitAnimation: !isLast,
      builder: (context, delete) => Card(
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.grey, width: 0),
          borderRadius: BorderRadius.circular(16),
        ),
        color: Colors.transparent,
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        notification.title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    if (!notification.subTitle.isNullOrEmpty)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          notification.subTitle!,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.only(left: 2.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          DateFormat("d.M.yy H:mm")
                              .format(notification.timeSent),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (notification.type != "message")
                IconButton(
                  icon: const Icon(
                    Icons.done,
                  ),
                  tooltip: "Gelesen",
                  onPressed: noInternet!
                      ? null
                      : () async {
                          await delete();
                          onDelete(notification);
                        },
                )
              else
                IconButton(
                  icon: const Icon(
                    Icons.exit_to_app,
                  ),
                  tooltip: "Zu Mitteilungen wechseln",
                  onPressed: () => goToMessage(notification.objectId!),
                )
            ],
          ),
        ),
      ),
    );
  }
}
