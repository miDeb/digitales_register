part of 'middleware.dart';

final _messagesMiddleware =
    MiddlewareBuilder<AppState, AppStateBuilder, AppActions>()
      ..add(MessagesActionsNames.load, _loadMessages);

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
