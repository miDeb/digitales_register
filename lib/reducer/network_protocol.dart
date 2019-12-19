import 'package:redux/redux.dart';

import '../actions/app_actions.dart';
import '../app_state.dart';

final networkProtocolReducer = TypedReducer(_networkProtocolReducer);

NetworkProtocolStateBuilder _networkProtocolReducer(
    NetworkProtocolStateBuilder state, AddNetworkProtocolItemAction action) {
  return (state ?? NetworkProtocolStateBuilder())..items.add(action.item);
}
