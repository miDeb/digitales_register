import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:quill_delta_viewer/quill_delta_viewer.dart';
import 'package:responsive_scaffold/responsive_scaffold.dart';

import '../app_state.dart';
import '../data.dart';
import 'no_internet.dart';

typedef MessageCallback = void Function(Message message);

class MessagesPage extends StatelessWidget {
  final MessagesState? state;
  final bool noInternet;
  final MessageCallback onDownloadFile;
  final MessageCallback onOpenFile;
  final MessageCallback onMarkAsRead;

  const MessagesPage(
      {Key? key,
      required this.state,
      required this.noInternet,
      required this.onDownloadFile,
      required this.onOpenFile,
      required this.onMarkAsRead})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ResponsiveAppBar(
        title: Text("Mitteilungen"),
      ),
      body: state == null
          ? noInternet
              ? const NoInternet()
              : const Center(child: CircularProgressIndicator())
          : Stack(
              children: <Widget>[
                if (state!.showMessage != null &&
                    !state!.messages.any((m) => m.id == state!.showMessage))
                  const LinearProgressIndicator()
                else if (state!.messages.isEmpty)
                  Center(
                    child: Text(
                      "Noch keine Mitteilungen",
                      style: Theme.of(context).textTheme.headline4,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ListView.builder(
                  itemCount: state!.messages.length,
                  itemBuilder: (context, i) {
                    return MessageWidget(
                      message: state!.messages[i],
                      onDownloadFile: onDownloadFile,
                      onOpenFile: onOpenFile,
                      onMarkAsRead: onMarkAsRead,
                      noInternet: noInternet,
                      expand: state!.messages[i].id == state!.showMessage,
                    );
                  },
                ),
              ],
            ),
    );
  }
}

class MessageWidget extends StatefulWidget {
  final Message message;
  final MessageCallback onDownloadFile;
  final MessageCallback onOpenFile;
  final MessageCallback onMarkAsRead;
  final bool noInternet;
  final bool expand;

  const MessageWidget({
    Key? key,
    required this.message,
    required this.onDownloadFile,
    required this.onOpenFile,
    required this.noInternet,
    required this.onMarkAsRead,
    required this.expand,
  }) : super(key: key);

  @override
  _MessageWidgetState createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {
  late final bool initiallyExpanded;
  @override
  void initState() {
    initiallyExpanded = widget.expand;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (initiallyExpanded) {
      widget.onMarkAsRead(widget.message);
    }
    final textTheme = Theme.of(context).textTheme;
    return ExpansionTile(
      initiallyExpanded: initiallyExpanded,
      onExpansionChanged: (expanded) {
        if (expanded && widget.message.isNew) {
          widget.onMarkAsRead(widget.message);
        }
      },
      title: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              widget.message.subject,
              style: textTheme.subtitle1,
            ),
          ),
          if (widget.message.isNew || initiallyExpanded)
            Badge(
              shape: BadgeShape.square,
              borderRadius: BorderRadius.circular(20),
              badgeContent: const Text(
                "neu",
                style: TextStyle(color: Colors.white),
              ),
            )
        ],
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ).copyWith(
            bottom: 8,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(
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
                    const TextSpan(
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
                    const TextSpan(
                      text: "An: ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: widget.message.recipientString)
                  ],
                ),
              ),
              const Divider(),
              renderMessage(widget.message.text, context),
              if (widget.message.fileName != null) ...[
                const Divider(),
                const Text(
                  "Anhang:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  widget.message.fileOriginalName!,
                ),
                if (widget.message.downloading) const LinearProgressIndicator(),
                if (!widget.message.fileAvailable)
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: widget.noInternet
                          ? null
                          : () {
                              widget.onDownloadFile(widget.message);
                            },
                      child: const Text("Herunterladen"),
                    ),
                  ),
                if (widget.message.fileAvailable)
                  IntrinsicHeight(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextButton(
                            onPressed: widget.noInternet
                                ? null
                                : () {
                                    widget.onDownloadFile(widget.message);
                                  },
                            child: const Text("Erneut herunterladen"),
                          ),
                        ),
                        const VerticalDivider(
                          indent: 8,
                          endIndent: 8,
                        ),
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              widget.onOpenFile(widget.message);
                            },
                            child: const Text("Öffnen"),
                          ),
                        ),
                      ],
                    ),
                  )
              ],
            ],
          ),
        ),
      ],
    );
  }
}

Widget renderMessage(String msg, BuildContext context) {
  return QuillDeltaViewer(
      delta: Delta.fromJson(jsonDecode(msg)["ops"] as List));
}
