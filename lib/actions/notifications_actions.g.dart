// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifications_actions.dart';

// **************************************************************************
// BuiltReduxGenerator
// **************************************************************************

// ignore_for_file: avoid_classes_with_only_static_members
// ignore_for_file: annotate_overrides
// ignore_for_file: overridden_fields
// ignore_for_file: type_annotate_public_apis

class _$NotificationsActions extends NotificationsActions {
  factory _$NotificationsActions() => _$NotificationsActions._();
  _$NotificationsActions._() : super._();

  final load = ActionDispatcher<void>('NotificationsActions-load');
  final loaded = ActionDispatcher<dynamic>('NotificationsActions-loaded');
  final delete = ActionDispatcher<Notification>('NotificationsActions-delete');
  final deleteAll = ActionDispatcher<void>('NotificationsActions-deleteAll');

  @override
  void setDispatcher(Dispatcher dispatcher) {
    load.setDispatcher(dispatcher);
    loaded.setDispatcher(dispatcher);
    delete.setDispatcher(dispatcher);
    deleteAll.setDispatcher(dispatcher);
  }
}

class NotificationsActionsNames {
  static final load = ActionName<void>('NotificationsActions-load');
  static final loaded = ActionName<dynamic>('NotificationsActions-loaded');
  static final delete = ActionName<Notification>('NotificationsActions-delete');
  static final deleteAll = ActionName<void>('NotificationsActions-deleteAll');
}
