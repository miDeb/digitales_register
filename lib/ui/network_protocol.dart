import 'package:dr/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app_state.dart';

class NetworkProtocol extends StatelessWidget {
  final List<NetworkProtocolItem> items;

  const NetworkProtocol({Key? key, required this.items}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return items.isEmpty
        ? const Center(
            child: Text("Nichts vorhanden"),
          )
        : ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              return _Item(
                item: items[index],
              );
            },
          );
  }
}

class _Item extends StatelessWidget {
  final NetworkProtocolItem item;

  const _Item({Key? key, required this.item}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(item.address),
      children: <Widget>[
        _Detail(
          type: "Parameter",
          content: item.parameters,
        ),
        _Detail(
          type: "Antwort",
          content: item.response,
        ),
      ],
    );
  }
}

class _Detail extends StatelessWidget {
  final String type;
  final String? content;

  const _Detail({Key? key, required this.type, this.content}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(type),
              IconButton(
                icon: const Icon(Icons.assignment),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: content));
                  showSnackBar("In die Zwischenablage kopiert");
                },
              )
            ],
          ),
          Text(content ?? "Keine $type"),
        ],
      ),
    );
  }
}
