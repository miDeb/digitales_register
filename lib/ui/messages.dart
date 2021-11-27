// Copyright (C) 2021 Michael Debertol
//
// This file is part of digitales_register.
//
// digitales_register is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// digitales_register is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with digitales_register.  If not, see <http://www.gnu.org/licenses/>.

import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:dr/ui/last_fetched_overlay.dart';
import 'package:dr/util.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:quill_delta_viewer/quill_delta_viewer.dart';
import 'package:responsive_scaffold/responsive_scaffold.dart';

import '../app_state.dart';
import '../data.dart';
import 'animated_linear_progress_indicator.dart';
import 'no_internet.dart';

class MessagesPage extends StatelessWidget {
  final MessagesState? state;
  final bool noInternet;
  final void Function(MessageAttachmentFile message) onDownloadFile;
  final void Function(MessageAttachmentFile message) onOpenFile;
  final void Function(Message message) onMarkAsRead;

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
          : LastFetchedOverlay(
              lastFetched: state!.lastFetched,
              noInternet: noInternet,
              child: Stack(
                children: <Widget>[
                  AnimatedLinearProgressIndicator(
                    show: state!.showMessage != null &&
                        !state!.messages.any((m) => m.id == state!.showMessage),
                  ),
                  if (state!.messages.isEmpty)
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
            ),
    );
  }
}

class MessageWidget extends StatefulWidget {
  final Message message;
  final void Function(MessageAttachmentFile message) onDownloadFile;
  final void Function(MessageAttachmentFile message) onOpenFile;
  final void Function(Message message) onMarkAsRead;
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
              if (widget.message.attachments.isNotEmpty) ...[
                const Divider(),
                Text(
                  widget.message.attachments.length > 1
                      ? "Anhänge:"
                      : "Anhang:",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
              ...[
                for (final attachment in widget.message.attachments)
                  [
                    Text(
                      attachment.originalName,
                    ),
                    AnimatedLinearProgressIndicator(
                        show: attachment.downloading),
                    if (!attachment.fileAvailable)
                      SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          onPressed: widget.noInternet
                              ? null
                              : () {
                                  widget.onDownloadFile(attachment);
                                },
                          child: const Text("Herunterladen"),
                        ),
                      ),
                    if (attachment.fileAvailable)
                      IntrinsicHeight(
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: TextButton(
                                onPressed: widget.noInternet
                                    ? null
                                    : () {
                                        widget.onDownloadFile(attachment);
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
                                  widget.onOpenFile(attachment);
                                },
                                child: const Text("Öffnen"),
                              ),
                            ),
                          ],
                        ),
                      )
                  ]
              ].intersperse(const Divider()),
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
