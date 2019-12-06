import 'package:flutter/material.dart';

class SubIcon extends StatelessWidget {
  final IconData icon;
  final IconData subIcon;
  final Color subIconColor, backgroundColor;

  const SubIcon(
      {Key key,
      @required this.icon,
      @required this.subIcon,
      this.subIconColor,
      @required this.backgroundColor})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Icon(icon),
        Positioned(
          bottom: -1.75,
          right: -1.75,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: backgroundColor,
            ),
            child: Icon(
              subIcon,
              size: 13.25,
              color: subIconColor,
            ),
          ),
        ),
      ],
    );
  }
}
