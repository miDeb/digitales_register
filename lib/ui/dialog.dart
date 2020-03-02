import 'package:flutter/material.dart';

class ListViewCapableAlertDialog extends StatelessWidget {
  final Widget title;
  final Widget content;
  final List<Widget> actions;
  final EdgeInsetsGeometry titlePadding;
  const ListViewCapableAlertDialog(
      {Key key, this.title, this.content, this.actions, this.titlePadding})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: title,
      content: Container(
        width: double.maxFinite,
        child: content,
      ),
      actions: actions,
      titlePadding: titlePadding,
    );
  }
}
