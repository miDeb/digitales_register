import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:quill_delta_viewer/quill_delta_viewer.dart';

import '../app_state.dart';
import '../data.dart';
import 'no_internet.dart';

typedef void MessageCallback(Message message);

class MessagesPage extends StatelessWidget {
  final MessagesState state;
  final bool noInternet;
  final MessageCallback onDownloadFile;
  final MessageCallback onOpenFile;

  const MessagesPage(
      {Key key,
      @required this.state,
      this.noInternet,
      this.onDownloadFile,
      this.onOpenFile})
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
          : ListView.builder(
              itemCount: state.messages.length,
              itemBuilder: (context, i) {
                return MessageWidget(
                  message: state.messages[i],
                  onDownloadFile: onDownloadFile,
                  onOpenFile: onOpenFile,
                );
              },
            ),
    );
  }
}

class MessageWidget extends StatefulWidget {
  final Message message;
  final MessageCallback onDownloadFile;
  final MessageCallback onOpenFile;

  const MessageWidget(
      {Key key, this.message, this.onDownloadFile, this.onOpenFile})
      : super(key: key);

  @override
  _MessageWidgetState createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey, width: 0),
        borderRadius: BorderRadius.circular(16),
      ),
      color: Colors.transparent,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.message.subject,
              style: textTheme.subhead,
            ),
            Divider(),
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
            Divider(),
            renderMessage(widget.message.text, context),
            if (widget.message.fileName != null) ...[
              Divider(),
              Text(
                "Anhang:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      widget.message.fileOriginalName,
                    ),
                  ),
                ],
              ),
              if (widget.message.downloading) LinearProgressIndicator(),
              if (!widget.message.fileAvailable)
                FlatButton(
                  child: Text("Herunterladen"),
                  onPressed: () {
                    widget.onDownloadFile(widget.message);
                  },
                ),
              if (widget.message.fileAvailable)
                IntrinsicHeight(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: FlatButton(
                          child: Text("Erneut herunterladen"),
                          onPressed: () {
                            widget.onDownloadFile(widget.message);
                          },
                        ),
                      ),
                      VerticalDivider(
                        indent: 8,
                        endIndent: 8,
                      ),
                      Expanded(
                        child: FlatButton(
                          child: Text("Öffnen"),
                          onPressed: () {
                            widget.onOpenFile(widget.message);
                          },
                        ),
                      ),
                    ],
                  ),
                )
            ]
          ],
        ),
      ),
    );
  }
}

Widget renderMessage(String msg, BuildContext context) {
  return QuillDeltaViewer(delta: Delta.fromJson(jsonDecode(msg)["ops"]));
}
