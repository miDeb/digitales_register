import 'package:deleteable_tile/deleteable_tile.dart';
import 'package:flutter/material.dart' hide Notification;
import 'package:intl/intl.dart';

import '../data.dart';
import '../main.dart';
import '../util.dart';

class NotificationPage extends StatelessWidget {
  final List<Notification> notifications;
  final SingleArgumentVoidCallback<Notification> deleteNotification;
  final SingleArgumentVoidCallback<int> goToMessage;
  final VoidCallback deleteAllNotifications;
  final bool noInternet;

  const NotificationPage({
    Key? key,
    required this.notifications,
    required this.deleteNotification,
    required this.deleteAllNotifications,
    required this.noInternet,
    required this.goToMessage,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Benachrichtigungen"),
      ),
      body: AnimatedCrossFade(
        firstChild: ListView.builder(
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
            );
          },
        ),
        secondChild: Center(
          child: Text(
            "Keine Benachrichtigungen",
            style: Theme.of(context).textTheme.headline4,
            textAlign: TextAlign.center,
          ),
        ),
        crossFadeState: notifications.isEmpty
            ? CrossFadeState.showSecond
            : CrossFadeState.showFirst,
        duration: const Duration(milliseconds: 250),
      ),
    );
  }
}

class NotificationWidget extends StatelessWidget {
  final Notification notification;
  final bool? noInternet;
  final SingleArgumentVoidCallback<Notification> onDelete;
  final SingleArgumentVoidCallback<int> goToMessage;

  const NotificationWidget(
      {Key? key,
      required this.notification,
      required this.onDelete,
      required this.noInternet,
      required this.goToMessage})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Deleteable(
      showEntryAnimation: false,
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
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    ),
                    if (!notification.subTitle.isNullOrEmpty)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          notification.subTitle!,
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.only(left: 2.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          DateFormat("d.M.yy H:mm")
                              .format(notification.timeSent),
                          style: Theme.of(context).textTheme.caption,
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
