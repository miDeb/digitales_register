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

part of 'middleware.dart';

final _messagesMiddleware =
    MiddlewareBuilder<AppState, AppStateBuilder, AppActions>()
      ..add(MessagesActionsNames.load, _loadMessages)
      ..add(MessagesActionsNames.markAsRead, _markAsRead)
      ..add(MessagesActionsNames.openFile, _openFile);

Future<void> _loadMessages(
    MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next,
    Action<void> action) async {
  if (api.state.noInternet) return;
  await next(action);
  final dynamic response = await wrapper.send("api/message/getMyMessages");
  if (response != null) {
    await api.actions.messagesActions.loaded(response as List);
  }
}

Future<void> _openFile(MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next, Action<MessageAttachmentFile> action) async {
  await next(action);

  if (!action.payload.fileAvailable ||
      !await canOpenFile(action.payload.uniqueName)) {
    await api.actions.messagesActions.downloadFile(action.payload);

    final success = await downloadFile(
      "${wrapper.baseAddress}api/message/messageSubmissionDownloadEntry",
      action.payload.uniqueName,
      <String, dynamic>{
        "messageId": action.payload.messageId,
        "submissionId": action.payload.id,
      },
    );
    await api.actions.messagesActions.fileAvailable(
        action.payload.rebuild((b) => b..fileAvailable = success));
    if (!success) {
      return;
    }
  }

  await openFile(action.payload.uniqueName);
}

Future<void> _markAsRead(
    MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next,
    Action<int> action) async {
  await next(action);
  await wrapper.send(
    "api/message/markAsRead",
    args: {"messageId": action.payload},
  );
}
