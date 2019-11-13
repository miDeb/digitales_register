import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app_state.dart';

class NetworkProtocol extends StatelessWidget {
  final List<NetworkProtocolItem> items;

  const NetworkProtocol({Key key, this.items}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return items.isEmpty
        ? Center(
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

  const _Item({Key key, this.item}) : super(key: key);
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
  final String content;

  const _Detail({Key key, this.type, this.content}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(type),
            IconButton(
              icon: Icon(Icons.assignment),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: content));
              },
            )
          ],
        ),
        Text(content ?? "Keine $type"),
      ],
    );
  }
}
