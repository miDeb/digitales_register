import 'package:built_value/built_value.dart';

import '../app_state.dart';

part 'app_actions.g.dart';

abstract class ErrorAction implements Built<ErrorAction, ErrorActionBuilder> {
  ErrorAction._();
  factory ErrorAction([void Function(ErrorActionBuilder) updates]) =
      _$ErrorAction;

  Error get e;
}

/// Immediately save state!
abstract class SaveStateAction
    implements Built<SaveStateAction, SaveStateActionBuilder> {
  SaveStateAction._();
  factory SaveStateAction([void Function(SaveStateActionBuilder) updates]) =
      _$SaveStateAction;
}

abstract class DeleteDataAction
    implements Built<DeleteDataAction, DeleteDataActionBuilder> {
  DeleteDataAction._();
  factory DeleteDataAction([void Function(DeleteDataActionBuilder) updates]) =
      _$DeleteDataAction;
}

/// Dispatched when starting the app to trigger all the load logic
abstract class LoadAction implements Built<LoadAction, LoadActionBuilder> {
  LoadAction._();
  factory LoadAction([void Function(LoadActionBuilder) updates]) = _$LoadAction;
}

abstract class RefreshNoInternetAction
    implements Built<RefreshNoInternetAction, RefreshNoInternetActionBuilder> {
  RefreshNoInternetAction._();
  factory RefreshNoInternetAction(
          [void Function(RefreshNoInternetActionBuilder) updates]) =
      _$RefreshNoInternetAction;
}

abstract class NoInternetAction
    implements Built<NoInternetAction, NoInternetActionBuilder> {
  NoInternetAction._();
  factory NoInternetAction([void Function(NoInternetActionBuilder) updates]) =
      _$NoInternetAction;

  bool get noInternet;
}

abstract class SetRouteIsLoginAction
    implements Built<SetRouteIsLoginAction, SetRouteIsLoginActionBuilder> {
  SetRouteIsLoginAction._();
  factory SetRouteIsLoginAction(
          [void Function(SetRouteIsLoginActionBuilder) updates]) =
      _$SetRouteIsLoginAction;

  bool get isLogin;
}

abstract class SetConfigAction
    implements Built<SetConfigAction, SetConfigActionBuilder> {
  SetConfigAction._();
  factory SetConfigAction([void Function(SetConfigActionBuilder) updates]) =
      _$SetConfigAction;

  Config get config;
}

abstract class MountAppStateAction
    implements Built<MountAppStateAction, MountAppStateActionBuilder> {
  MountAppStateAction._();
  factory MountAppStateAction(
          [void Function(MountAppStateActionBuilder) updates]) =
      _$MountAppStateAction;

  static void _initializeBuilder(MountAppStateActionBuilder builder) {
    builder..appState = AppStateBuilder();
  }

  AppState get appState;
}

abstract class AddNetworkProtocolItemAction
    implements
        Built<AddNetworkProtocolItemAction,
            AddNetworkProtocolItemActionBuilder> {
  AddNetworkProtocolItemAction._();
  factory AddNetworkProtocolItemAction(
          [void Function(AddNetworkProtocolItemActionBuilder) updates]) =
      _$AddNetworkProtocolItemAction;

  NetworkProtocolItem get item;
}
