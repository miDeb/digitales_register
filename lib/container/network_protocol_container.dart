import 'package:dr/actions/app_actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_built_redux/flutter_built_redux.dart';

import '../app_state.dart';
import '../ui/network_protocol.dart';

class NetworkProtocolContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnection<AppState, AppActions, List<NetworkProtocolItem>>(
      builder: (context, vm, actions) {
        return NetworkProtocol(items: vm);
      },
      connect: (state) {
        return state.networkProtocolState.items.toList();
      },
    );
  }
}
