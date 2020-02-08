// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'absences_actions.dart';

// **************************************************************************
// BuiltReduxGenerator
// **************************************************************************

// ignore_for_file: avoid_classes_with_only_static_members
// ignore_for_file: annotate_overrides
// ignore_for_file: overridden_fields
// ignore_for_file: type_annotate_public_apis

class _$AbsencesActions extends AbsencesActions {
  factory _$AbsencesActions() => _$AbsencesActions._();
  _$AbsencesActions._() : super._();

  final load = ActionDispatcher<void>('AbsencesActions-load');
  final loaded = ActionDispatcher<dynamic>('AbsencesActions-loaded');

  @override
  void setDispatcher(Dispatcher dispatcher) {
    load.setDispatcher(dispatcher);
    loaded.setDispatcher(dispatcher);
  }
}

class AbsencesActionsNames {
  static final load = ActionName<void>('AbsencesActions-load');
  static final loaded = ActionName<dynamic>('AbsencesActions-loaded');
}
