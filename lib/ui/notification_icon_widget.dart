import 'package:flutter/material.dart';

import '../container/notification_icon.dart';
import 'news_sticker.dart';

class NotificationIconWidget extends StatelessWidget {
  final NotificationIconViewModel vm;

  const NotificationIconWidget({Key key, this.vm}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return vm.notifications != 0
        ? IconButton(
            icon: Stack(
              fit: StackFit.expand,
              children: [
                Icon(Icons.notifications),
                Align(
                  child: NewsSticker(
                    text: vm.notifications.toString(),
                  ),
                  alignment: Alignment(
                    -1.2,
                    1,
                  ),
                ),
              ],
            ),
            onPressed: () {
              vm.onTap();
            },
          )
        : SizedBox();
  }
}
