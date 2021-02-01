import 'package:built_redux/built_redux.dart';

import '../data.dart';

part 'messages_actions.g.dart';

abstract class MessagesActions extends ReduxActions {
  factory MessagesActions() => _$MessagesActions();
  MessagesActions._();

  VoidActionDispatcher load;
  ActionDispatcher<List> loaded;
  ActionDispatcher<Message> downloadFile;
  ActionDispatcher<Message> fileAvailable;
  ActionDispatcher<Message> openFile;
  ActionDispatcher<int> markAsRead;
}
