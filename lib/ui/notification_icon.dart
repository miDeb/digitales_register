import 'package:badges/badges.dart';
import 'package:flutter/material.dart';

class NotificationIcon extends StatelessWidget {
  final int notifications;
  final VoidCallback onTap;

  const NotificationIcon({Key key, this.notifications, this.onTap}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return notifications != 0
        ? IconButton(
            icon: Badge(
              child: Icon(Icons.notifications),
              badgeContent: Text(
                notifications.toString(),
                style: TextStyle(color: Colors.white),
              ),
              position: BadgePosition.bottomLeft(),
            ),
            onPressed: onTap,
          )
        : SizedBox();
  }
}
