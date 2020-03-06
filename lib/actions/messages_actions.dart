import 'package:built_redux/built_redux.dart';

part 'messages_actions.g.dart';

abstract class MessagesActions extends ReduxActions {
  MessagesActions._();
  factory MessagesActions() => _$MessagesActions();

  ActionDispatcher<void> load;
  ActionDispatcher<dynamic> loaded;
}
