import 'package:built_collection/built_collection.dart';
import 'package:built_redux/built_redux.dart';

import '../actions/messages_actions.dart';
import '../app_state.dart';
import '../data.dart';

final messagesReducerBuilder = NestedReducerBuilder<AppState, AppStateBuilder,
    MessagesState, MessagesStateBuilder>(
  (s) => s.messagesState,
  (b) => b.messagesState,
)
  ..add(MessagesActionsNames.loaded, _loaded)
  ..add(MessagesActionsNames.fileAvailable, _fileAvailable)
  ..add(MessagesActionsNames.downloadFile, _downloadFile);

void _loaded(
    MessagesState state, Action<Object> action, MessagesStateBuilder builder) {
  return builder.replace(_parseMessages(action.payload, state));
}

void _downloadFile(
    MessagesState state, Action<Message> action, MessagesStateBuilder builder) {
  builder.messages[
          state.messages.indexWhere((m) => m.id == action.payload.id)] =
      action.payload.rebuild((b) => b.downloading = true);
}

void _fileAvailable(
    MessagesState state, Action<Message> action, MessagesStateBuilder builder) {
  builder.messages[
          state.messages.indexWhere((m) => m.id == action.payload.id)] =
      action.payload.rebuild((b) => b
        ..fileAvailable = true
        ..downloading = false);
}

MessagesState _parseMessages(json, MessagesState state) {
  final messages = json.map((m) {
    final message = MessageBuilder()
      ..subject = m["subject"]
      ..text = m["text"]
      ..timeSent = DateTime.parse(
        m["timeSent"],
      )
      ..timeRead = m["timeRead"] != null
          ? DateTime.parse(
              m["timeRead"],
            )
          : null
      ..recipientString = m["recipientString"]
      ..fromName = m["fromName"]
      ..fileName = m["fileName"]
      ..fileOriginalName = m["fileOriginalName"]
      ..id = m["id"];
    final oldMessage = state.messages.firstWhere(
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
