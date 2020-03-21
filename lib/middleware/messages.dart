part of 'middleware.dart';

final _messagesMiddleware =
    MiddlewareBuilder<AppState, AppStateBuilder, AppActions>()
      ..add(MessagesActionsNames.load, _loadMessages)
      ..add(MessagesActionsNames.markAsRead, _markAsRead)
      ..add(MessagesActionsNames.downloadFile, _downloadFile)
      ..add(MessagesActionsNames.openFile, _openFile);

void _loadMessages(MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next, Action<void> action) async {
  if (api.state.noInternet) return;
  next(action);
  final response = await _wrapper.send("/api/message/getMyMessages");
  if (response != null) {
    api.actions.messagesActions.loaded(response);
  } else {
    api.actions.refreshNoInternet();
  }
}

void _downloadFile(MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next, Action<Message> action) async {
  if (api.state.noInternet) return;
  next(action);
  if (!Platform.isLinux) {
    final permissions = await PermissionsPlugin.requestPermissions([
      Permission.WRITE_EXTERNAL_STORAGE,
    ]);
    if (permissions[Permission.WRITE_EXTERNAL_STORAGE] !=
        PermissionState.GRANTED) {
      showToast(msg: "Abbruch");
      return;
    }
  }
  final saveFile = File(
    (await downloadsDirectory).path + "/" + action.payload.fileOriginalName,
  );

  final result = await _wrapper.dio.download(
    "${_wrapper.baseAddress}/api/message/download",
    saveFile.path,
    queryParameters: {
      "messageId": action.payload.id,
      "fileName": action.payload.fileName,
    },
  );
  if (result.statusCode == 200) {
    showToast(msg: "Heruntergeladen");
    api.actions.messagesActions.fileAvailable(action.payload);
  }
}

void _openFile(MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next, Action<Message> action) async {
  next(action);
  final saveFile = File(
    (await DownloadsPathProvider.downloadsDirectory).path +
        "/" +
        action.payload.fileOriginalName,
  );
  await OpenFile.open(saveFile.path);
}

void _markAsRead(MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next, Action<int> action) async {
  next(action);
  final result = await _wrapper.send(
    "/api/message/markAsRead",
    args: {"messageId": action.payload},
  );
  if (result == null) api.actions.refreshNoInternet();
}
