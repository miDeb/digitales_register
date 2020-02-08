// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'save_pass_actions.dart';

// **************************************************************************
// BuiltReduxGenerator
// **************************************************************************

// ignore_for_file: avoid_classes_with_only_static_members
// ignore_for_file: annotate_overrides
// ignore_for_file: overridden_fields
// ignore_for_file: type_annotate_public_apis

class _$SavePassActions extends SavePassActions {
  factory _$SavePassActions() => _$SavePassActions._();
  _$SavePassActions._() : super._();

  final save = ActionDispatcher<void>('SavePassActions-save');
  final delete = ActionDispatcher<void>('SavePassActions-delete');

  @override
  void setDispatcher(Dispatcher dispatcher) {
    save.setDispatcher(dispatcher);
    delete.setDispatcher(dispatcher);
  }
}

class SavePassActionsNames {
  static final save = ActionName<void>('SavePassActions-save');
  static final delete = ActionName<void>('SavePassActions-delete');
}
