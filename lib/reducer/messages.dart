import 'package:built_collection/built_collection.dart';
import 'package:built_redux/built_redux.dart';
import 'package:dr/actions/routing_actions.dart';

import '../actions/messages_actions.dart';
import '../app_state.dart';
import '../data.dart';

final messagesReducerBuilder = NestedReducerBuilder<AppState, AppStateBuilder,
    MessagesState, MessagesStateBuilder>(
  (s) => s.messagesState,
  (b) => b.messagesState,
)
  ..add(MessagesActionsNames.loaded, _loaded)
  ..add(RoutingActionsNames.showMessage, _showMessage)
  ..add(MessagesActionsNames.fileAvailable, _fileAvailable)
  ..add(MessagesActionsNames.downloadFile, _downloadFile)
  ..add(MessagesActionsNames.markAsRead, _markAsRead);

void _loaded(
    MessagesState state, Action<List> action, MessagesStateBuilder builder) {
  return builder.replace(_parseMessages(action.payload, state));
}

void _showMessage(
    MessagesState state, Action<int> action, MessagesStateBuilder builder) {
  builder.showMessage = action.payload;
}

void _downloadFile(
    MessagesState state, Action<Message> action, MessagesStateBuilder builder) {
  builder.messages[
          state.messages.indexWhere((m) => m.id == action.payload.id)] =
      action.payload.rebuild((b) => b.downloading = true);
}

void _fileAvailable(
    MessagesState state, Action<Message> action, MessagesStateBuilder builder) {
  builder.messages[state.messages
      .indexWhere((m) => m.id == action.payload.id)] = action.payload.rebuild(
    (b) => b
      ..fileAvailable = true
      ..downloading = false,
  );
}

void _markAsRead(
    MessagesState state, Action<int> action, MessagesStateBuilder builder) {
  if (action.payload == state.showMessage) {
    builder.showMessage = null;
  }
  builder.messages[state.messages.indexWhere((m) => m.id == action.payload)] =
      state.messages
          .firstWhere(
            (m) => m.id == action.payload,
          )
          .rebuild(
            (b) => b..timeRead = DateTime.now(),
          );
}

MessagesState _parseMessages(List json, MessagesState state) {
  final messages = json.map((m) {
    final message = MessageBuilder()
      ..subject = m["subject"] as String
      ..text = m["text"] as String
      ..timeSent = DateTime.parse(
        m["timeSent"] as String,
      )
      ..timeRead = m["timeRead"] != null
          ? DateTime.parse(
              m["timeRead"] as String,
            )
          : null
      ..recipientString = m["recipientString"] as String
      ..fromName = m["fromName"] as String
      ..fileName = m["fileName"] as String
      ..fileOriginalName = m["fileOriginalName"] as String
      ..id = m["id"] as int;
    final oldMessage = state?.messages?.firstWhere(
      (m) => m.id == message.id,
      orElse: () => null,
    );
    if (oldMessage != null && oldMessage.fileName == message.fileName) {
      message.fileAvailable = oldMessage.fileAvailable;
    }
    return message.build();
  }).toList();
  return MessagesState(
    (b) => b..messages = ListBuilder<Message>(messages),
  );
}
