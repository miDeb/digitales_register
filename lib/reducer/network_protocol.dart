import 'package:built_redux/built_redux.dart';

import '../actions/app_actions.dart';
import '../app_state.dart';

final networkProtocolReducerBuilder = NestedReducerBuilder<AppState, AppStateBuilder,
    NetworkProtocolState, NetworkProtocolStateBuilder>(
  (s) => s.networkProtocolState,
  (b) => b.networkProtocolState,
)..add(AppActionsNames.addNetworkProtocolItem, _networkProtocol);

void _networkProtocol(NetworkProtocolState state, Action<NetworkProtocolItem> action,
    NetworkProtocolStateBuilder builder) {
  builder.items.add(action.payload);
}
