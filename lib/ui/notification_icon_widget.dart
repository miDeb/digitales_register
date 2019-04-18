import 'package:flutter/material.dart';

import '../container/notification_icon.dart';

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
                  child: Container(
                    child: Text(
                      vm.notifications.toString(),
                      style: Theme.of(context).textTheme.body1.copyWith(
                            color: Colors.white,
                          ),
                    ),
                    decoration: ShapeDecoration(
                      color: Colors.red,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: Colors.red,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
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
