import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../app_state.dart';
import '../data.dart';
import 'no_internet.dart';

class MessagesPage extends StatelessWidget {
  final MessagesState state;
  final bool noInternet;

  const MessagesPage({Key key, @required this.state, this.noInternet})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mitteilungen"),
      ),
      body: state == null
          ? noInternet
              ? NoInternet()
              : Center(child: CircularProgressIndicator())
          : ListView.separated(
              itemCount: state.messages.length,
              itemBuilder: (context, i) {
                return MessageWidget(
                  message: state.messages[i],
                );
              },
              separatorBuilder: (_, __) => Divider(height: 0),
            ),
    );
  }
}

class MessageWidget extends StatefulWidget {
  final Message message;

  const MessageWidget({Key key, this.message}) : super(key: key);

  @override
  _MessageWidgetState createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.message.subject,
            style: textTheme.subhead,
          ),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "Gesendet: ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                    text: DateFormat("d.M.yy H:mm")
                        .format(widget.message.timeSent))
              ],
            ),
          ),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "Von: ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: widget.message.fromName)
              ],
            ),
          ),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "An: ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: widget.message.recipientString)
              ],
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Text.rich(renderMessage(widget.message.text, context))
        ],
      ),
    );
  }
}

TextSpan renderMessage(String msg, BuildContext context) {
  final json = jsonDecode(msg)["ops"];
  final rawStrings = <TextSpan>[];
  bool isLast = true;
  bool addBullet = false;
  for (final t in json.reversed) {
    final attributes = t["attributes"] ?? {};
    String text = t["insert"];
    if (isLast) {
      isLast = false;
      if (text[text.length - 1] == "\n") {
        text = text.substring(0, text.length - 1);
      }
    }
    if (addBullet && text.contains("\n")) {
      final index = text.lastIndexOf("\n");
      text = text.substring(0, index) + "\n• " + text.substring(index + 1);
      addBullet = false;
    }
    bool isLink = attributes["link"] != null;
    rawStrings.add(
      TextSpan(
          text: text,
          style: TextStyle(
            fontWeight: attributes.containsKey("bold") ? FontWeight.bold : null,
            color: isLink ? Theme.of(context).accentColor : null,
          ),
          recognizer: isLink
              ? (TapGestureRecognizer()
                ..onTap = () {
                  launch(attributes["link"]);
                })
              : null),
    );
    if (attributes["list"] == "ordered") {
      addBullet = true;
    }
  }
  return TextSpan(children: rawStrings.reversed.toList());
}

// •
