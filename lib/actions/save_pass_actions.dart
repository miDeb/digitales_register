import 'package:built_redux/built_redux.dart';

part 'save_pass_actions.g.dart';

abstract class SavePassActions extends ReduxActions {
  factory SavePassActions() => _$SavePassActions();
  SavePassActions._();

  VoidActionDispatcher save;
  VoidActionDispatcher delete;
}
