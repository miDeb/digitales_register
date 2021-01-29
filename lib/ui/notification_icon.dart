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
              child: Icon(Icons.notifications),
              badgeContent: Text(
                notifications.toString(),
                style: TextStyle(color: Colors.white),
              ),
              position: BadgePosition.bottomEnd(),
            ),
            onPressed: onTap,
          )
        : SizedBox();
  }
}
