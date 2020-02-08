// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar_actions.dart';

// **************************************************************************
// BuiltReduxGenerator
// **************************************************************************

// ignore_for_file: avoid_classes_with_only_static_members
// ignore_for_file: annotate_overrides
// ignore_for_file: overridden_fields
// ignore_for_file: type_annotate_public_apis

class _$CalendarActions extends CalendarActions {
  factory _$CalendarActions() => _$CalendarActions._();
  _$CalendarActions._() : super._();

  final load = ActionDispatcher<DateTime>('CalendarActions-load');
  final loaded = ActionDispatcher<dynamic>('CalendarActions-loaded');
  final setCurrentMonday = ActionDispatcher<DateTime>('CalendarActions-setCurrentMonday');

  @override
  void setDispatcher(Dispatcher dispatcher) {
    load.setDispatcher(dispatcher);
    loaded.setDispatcher(dispatcher);
    setCurrentMonday.setDispatcher(dispatcher);
  }
}

class CalendarActionsNames {
  static final load = ActionName<DateTime>('CalendarActions-load');
  static final loaded = ActionName<dynamic>('CalendarActions-loaded');
  static final setCurrentMonday = ActionName<DateTime>('CalendarActions-setCurrentMonday');
}
