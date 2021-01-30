import 'package:flutter/material.dart';

/// Shows a close button
class InfoDialog extends StatelessWidget {
  final Widget title;
  final Widget content;
  final List<Widget> actions;

  const InfoDialog({
    Key key,
    this.title,
    this.content,
    this.actions,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: EdgeInsets.zero,
      title: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 24,
                right: 24,
                top: 24,
              ),
              child: title,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4, right: 4),
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
      content: content == null
          ? null
          : SizedBox(
              width: double.maxFinite,
              child: content,
            ),
      actions: actions,
    );
  }
}
