import 'package:built_value/built_value.dart';

part 'save_pass_actions.g.dart';

abstract class SavePassAction
    implements Built<SavePassAction, SavePassActionBuilder> {
  SavePassAction._();
  factory SavePassAction([void Function(SavePassActionBuilder) updates]) =
      _$SavePassAction;
}

abstract class DeletePassAction
    implements Built<DeletePassAction, DeletePassActionBuilder> {
  DeletePassAction._();
  factory DeletePassAction([void Function(DeletePassActionBuilder) updates]) =
      _$DeletePassAction;
}
