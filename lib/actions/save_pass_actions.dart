import 'package:built_redux/built_redux.dart';

part 'save_pass_actions.g.dart';

abstract class SavePassActions extends ReduxActions {
  SavePassActions._();
  factory SavePassActions() => _$SavePassActions();

  ActionDispatcher<void> save;
  ActionDispatcher<void> delete;
}
