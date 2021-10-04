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
