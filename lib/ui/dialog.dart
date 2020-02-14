import 'package:flutter/material.dart';

class ListViewCapableAlertDialog extends StatelessWidget {
  final Widget title;
  final Widget content;
  final List<Widget> actions;

  const ListViewCapableAlertDialog(
      {Key key, this.title, this.content, this.actions})
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
    );
  }
}
