import 'package:built_collection/built_collection.dart';
import 'package:built_redux/built_redux.dart';

import '../actions/messages_actions.dart';
import '../app_state.dart';
import '../data.dart';

final messagesReducerBuilder = NestedReducerBuilder<AppState, AppStateBuilder,
    MessagesState, MessagesStateBuilder>(
  (s) => s.messagesState,
  (b) => b.messagesState,
)..add(MessagesActionsNames.loaded, _loaded);

void _loaded(
    MessagesState state, Action<Object> action, MessagesStateBuilder builder) {
  return builder.replace(_parseMessages(action.payload));
}

MessagesState _parseMessages(json) {
  final messages = json.map((message) {
    return Message(
      (b) => b
        ..subject = message["subject"]
        ..text = message["text"]
        ..timeSent = DateTime.parse(
          message["timeSent"],
        )
        ..timeRead = message["timeRead"] != null
            ? DateTime.parse(
                message["timeRead"],
              )
            : null
        ..recipientString = message["recipientString"]
        ..fromName = message["fromName"],
    );
  }).toList();
  return MessagesState(
    (b) => b..messages = ListBuilder<Message>(messages),
  );
}
