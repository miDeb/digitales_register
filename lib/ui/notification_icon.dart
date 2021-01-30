import 'package:badges/badges.dart';
import 'package:flutter/material.dart';

class NotificationIcon extends StatelessWidget {
  final int notifications;
  final VoidCallback onTap;

  const NotificationIcon({Key key, this.notifications, this.onTap})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return notifications != 0
        ? IconButton(
            visualDensity: VisualDensity.standard,
            icon: Badge(
              badgeContent: Text(
                notifications.toString(),
                style: const TextStyle(color: Colors.white),
              ),
              position: BadgePosition.bottomEnd(),
              child: const Icon(Icons.notifications),
            ),
            onPressed: onTap,
          )
        : const SizedBox();
  }
}
