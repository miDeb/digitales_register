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
  final response = await _wrapper.send("api/message/getMyMessages");
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
  await next(action);
}

Future<void> _openFile(MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next, Action<Message> action) async {
  await next(action);
  final saveFile = File(
    action.payload.fileOriginalName,
  );
  await OpenFile.open(saveFile.path);
}

Future<void> _markAsRead(
    MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next,
    Action<int> action) async {
  await next(action);
  final result = await _wrapper.send(
    "api/message/markAsRead",
    args: {"messageId": action.payload},
  );
  if (result == null) api.actions.refreshNoInternet();
}
