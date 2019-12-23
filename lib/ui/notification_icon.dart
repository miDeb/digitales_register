import 'package:flutter/material.dart';

import 'news_sticker.dart';

class NotificationIcon extends StatelessWidget {
  final int notifications;
  final VoidCallback onTap;

  const NotificationIcon({Key key, this.notifications, this.onTap})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return notifications != 0
        ? IconButton(
            icon: Stack(
              fit: StackFit.expand,
              children: [
                Icon(Icons.notifications),
                Align(
                  child: NewsSticker(
                    text: notifications.toString(),
                  ),
                  alignment: Alignment(
                    -1.2,
                    1,
                  ),
                ),
              ],
            ),
            onPressed: onTap,
          )
        : SizedBox();
  }
}
