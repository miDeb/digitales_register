import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../app_state.dart';
import '../ui/network_protocol.dart';

class NetworkProtocolContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, List<NetworkProtocolItem>>(
      builder: (BuildContext context, List<NetworkProtocolItem> vm) {
        return NetworkProtocol(items: vm);
      },
      converter: (Store<AppState> store) {
        return store.state.networkProtocolState?.items?.toList() ?? [];
      },
    );
  }
}
