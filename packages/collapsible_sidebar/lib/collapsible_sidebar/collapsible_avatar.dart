import 'package:flutter/material.dart';

class CollapsibleAvatar extends StatelessWidget {
  const CollapsibleAvatar({
    @required this.avatarSize,
    @required this.name,
    this.avatar,
    @required this.textStyle,
  });

  final double avatarSize;
  final String name;
  final Widget avatar;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: avatarSize,
      width: avatarSize,
      child: avatar != null ? _avatar : _initials,
    );
  }

  Widget get _avatar {
    return avatar;
  }

  Widget get _initials {
    return Center(
      child: Text(
        '${name.substring(0, 1).toUpperCase()}',
        style: textStyle,
      ),
    );
  }
}
