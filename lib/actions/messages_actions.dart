import 'package:built_redux/built_redux.dart';

import '../data.dart';

part 'messages_actions.g.dart';

abstract class MessagesActions extends ReduxActions {
  factory MessagesActions() => _$MessagesActions();
  MessagesActions._();

  abstract final VoidActionDispatcher load;
  abstract final ActionDispatcher<List> loaded;
  abstract final ActionDispatcher<Message> downloadFile;
  abstract final ActionDispatcher<Message> fileAvailable;
  abstract final ActionDispatcher<Message> openFile;
  abstract final ActionDispatcher<int> markAsRead;
}
