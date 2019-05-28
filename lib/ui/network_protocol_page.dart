import 'package:flutter/material.dart';

import '../container/network_protocol_container.dart';

class NetworkProtocolPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Netzwerkprotokoll"),
      ),
      body: NetworkProtocolContainer(),
    );
  }
}
