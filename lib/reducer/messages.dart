import 'package:built_collection/built_collection.dart';
import 'package:built_redux/built_redux.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:dr/actions/routing_actions.dart';
import 'package:dr/util.dart';

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
  return builder.replace(tryParse(action.payload,
      (List<dynamic> payload) => _parseMessages(payload, state)));
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
            (b) => b..timeRead = now,
          );
}

MessagesState _parseMessages(List json, MessagesState state) {
  final messages = json
      .map((dynamic m) =>
          tryParse(getMap(m), (Map? m) => _parseMessage(m!, state)))
      .toList();
  return MessagesState(
    (b) => b..messages = ListBuilder<Message>(messages),
  );
}

Message _parseMessage(Map json, MessagesState state) {
  final message = MessageBuilder()
    ..subject = getString(json["subject"])
    ..text = getString(json["text"])
    ..timeSent = DateTime.parse(getString(json["timeSent"])!)
    ..timeRead = json["timeRead"] != null
        ? DateTime.parse(getString(json["timeRead"])!)
        : null
    ..recipientString = getString(json["recipientString"])
    ..fromName = getString(json["fromName"])
    ..fileName = getString(json["fileName"])
    ..fileOriginalName = getString(json["fileOriginalName"])
    ..id = getInt(json["id"]);
  final oldMessage = state.messages.firstWhereOrNull(
    (m) => m.id == message.id,
  );
  if (oldMessage != null && oldMessage.fileName == message.fileName) {
    message.fileAvailable = oldMessage.fileAvailable;
  }
  return message.build();
}
