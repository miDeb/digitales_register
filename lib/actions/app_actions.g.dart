// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_actions.dart';

// **************************************************************************
// BuiltReduxGenerator
// **************************************************************************

// ignore_for_file: avoid_classes_with_only_static_members
// ignore_for_file: annotate_overrides
// ignore_for_file: overridden_fields
// ignore_for_file: type_annotate_public_apis

class _$AppActions extends AppActions {
  factory _$AppActions() => _$AppActions._();
  _$AppActions._() : super._();

  final error = ActionDispatcher<Error>('AppActions-error');
  final saveState = ActionDispatcher<void>('AppActions-saveState');
  final deleteData = ActionDispatcher<void>('AppActions-deleteData');
  final load = ActionDispatcher<void>('AppActions-load');
  final refreshNoInternet = ActionDispatcher<bool>('AppActions-refreshNoInternet');
  final noInternet = ActionDispatcher<bool>('AppActions-noInternet');
  final isLoginRoute = ActionDispatcher<bool>('AppActions-isLoginRoute');
  final setConfig = ActionDispatcher<Config>('AppActions-setConfig');
  final mountAppState = ActionDispatcher<AppState>('AppActions-mountAppState');
  final addNetworkProtocolItem =
      ActionDispatcher<NetworkProtocolItem>('AppActions-addNetworkProtocolItem');

  final absencesActions = AbsencesActions();
  final calendarActions = CalendarActions();
  final dashboardActions = DashboardActions();
  final gradesActions = GradesActions();
  final loginActions = LoginActions();
  final notificationsActions = NotificationsActions();
  final routingActions = RoutingActions();
  final savePassActions = SavePassActions();
  final settingsActions = SettingsActions();

  @override
  void setDispatcher(Dispatcher dispatcher) {
    error.setDispatcher(dispatcher);
    saveState.setDispatcher(dispatcher);
    deleteData.setDispatcher(dispatcher);
    load.setDispatcher(dispatcher);
    refreshNoInternet.setDispatcher(dispatcher);
    noInternet.setDispatcher(dispatcher);
    isLoginRoute.setDispatcher(dispatcher);
    setConfig.setDispatcher(dispatcher);
    mountAppState.setDispatcher(dispatcher);
    addNetworkProtocolItem.setDispatcher(dispatcher);

    absencesActions.setDispatcher(dispatcher);
    calendarActions.setDispatcher(dispatcher);
    dashboardActions.setDispatcher(dispatcher);
    gradesActions.setDispatcher(dispatcher);
    loginActions.setDispatcher(dispatcher);
    notificationsActions.setDispatcher(dispatcher);
    routingActions.setDispatcher(dispatcher);
    savePassActions.setDispatcher(dispatcher);
    settingsActions.setDispatcher(dispatcher);
  }
}

class AppActionsNames {
  static final error = ActionName<Error>('AppActions-error');
  static final saveState = ActionName<void>('AppActions-saveState');
  static final deleteData = ActionName<void>('AppActions-deleteData');
  static final load = ActionName<void>('AppActions-load');
  static final refreshNoInternet = ActionName<bool>('AppActions-refreshNoInternet');
  static final noInternet = ActionName<bool>('AppActions-noInternet');
  static final isLoginRoute = ActionName<bool>('AppActions-isLoginRoute');
  static final setConfig = ActionName<Config>('AppActions-setConfig');
  static final mountAppState = ActionName<AppState>('AppActions-mountAppState');
  static final addNetworkProtocolItem =
      ActionName<NetworkProtocolItem>('AppActions-addNetworkProtocolItem');
}
