import 'package:flutter/material.dart';

class CollapsibleAvatar extends StatelessWidget {
  const CollapsibleAvatar({
    @required this.avatarSize,
    @required this.avatar,
    @required this.textStyle,
  });

  final double avatarSize;
  final Widget avatar;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: avatarSize,
      width: avatarSize,
      child: _avatar,
    );
  }

  Widget get _avatar {
    return avatar;
  }
}
