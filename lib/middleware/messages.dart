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
      ..add(MessagesActionsNames.downloadFile, _downloadFile)
      ..add(MessagesActionsNames.openFile, _openFile);

Future<void> _loadMessages(
    MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next,
    Action<void> action) async {
  if (api.state.noInternet) return;
  await next(action);
  final dynamic response = await wrapper.send("api/message/getMyMessages");
  if (response != null) {
    api.actions.messagesActions.loaded(response as List);
  } else {
    api.actions.refreshNoInternet();
  }
}

Future<void> _downloadFile(
    MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next,
    Action<Message> action) async {
  if (api.state.noInternet) return;
  final success = await downloadFile(
    "${wrapper.baseAddress}/api/message/download",
    action.payload.fileOriginalName!,
    <String, dynamic>{
      "messageId": action.payload.id,
      "fileName": action.payload.fileName,
    },
  );
  if (success) {
    showSnackBar("Heruntergeladen");
    api.actions.messagesActions.fileAvailable(action.payload);
  } else {
    showSnackBar("Download fehlgeschlagen");
  }
  await next(action);
}

Future<void> _openFile(MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next, Action<Message> action) async {
  await next(action);
  final saveFile = File(
      "${(await getApplicationDocumentsDirectory()).path}/${action.payload.fileOriginalName!}");
  await OpenFile.open(saveFile.path);
}

Future<void> _markAsRead(
    MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next,
    Action<int> action) async {
  await next(action);
  final dynamic result = await wrapper.send(
    "api/message/markAsRead",
    args: {"messageId": action.payload},
  );
  if (result == null) api.actions.refreshNoInternet();
}
