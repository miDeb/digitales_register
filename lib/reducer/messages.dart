// Copyright (C) 2021 Michael Debertol
//
// This file is part of digitales_register.
//
// digitales_register is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// digitales_register is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with digitales_register.  If not, see <http://www.gnu.org/licenses/>.

import 'package:built_collection/built_collection.dart';
import 'package:built_redux/built_redux.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:dr/actions/routing_actions.dart';
import 'package:dr/util.dart';

import '../actions/messages_actions.dart';
import '../app_state.dart';
import '../data.dart';
import '../utc_date_time.dart';

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
  return builder.replace(
    tryParse(
      action.payload,
      (List<dynamic> payload) => _parseMessages(payload, state),
    ),
  );
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
  final index = state.messages.indexWhere((m) => m.id == action.payload);
  if (index == -1) {
    // This means that we are trying to mark a message as read that has not been loaded yet.
    // This happens when marking a message as read via a notification.
    return;
  }
  builder.messages[index] = state.messages[index].rebuild(
    (b) => b..timeRead = now,
  );
}

MessagesState _parseMessages(List json, MessagesState state) {
  final messages = json
      .map((dynamic m) =>
          tryParse(getMap(m), (Map? m) => _parseMessage(m!, state)))
      .toList();
  return MessagesState(
    (b) => b
      ..messages = ListBuilder<Message>(messages)
      ..lastFetched = UtcDateTime.now(),
  );
}

Message _parseMessage(Map json, MessagesState state) {
  final message = MessageBuilder()
    ..subject = getString(json["subject"])
    ..text = getString(json["text"])
    ..timeSent = UtcDateTime.parse(getString(json["timeSent"])!)
    ..timeRead = json["timeRead"] != null
        ? UtcDateTime.parse(getString(json["timeRead"])!)
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
