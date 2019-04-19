import 'package:redux/redux.dart';

import '../actions.dart';
import '../app_state.dart';
import '../data.dart';
import '../wrapper.dart';

List<Middleware<AppState>> notificationsMiddlewares(Wrapper wrapper) => [
      TypedMiddleware<AppState, LoadNotificationsAction>(
        (store, action, next) => _load(next, action, wrapper, store),
      ),
      TypedMiddleware<AppState, DeleteNotificationAction>(
        (store, action, next) => _delete(wrapper, store, next, action),
      ),
      TypedMiddleware<AppState, DeleteAllNotificationsAction>(
        (store, action, next) => _deleteAll(wrapper, store, next, action),
      ),
    ];

void _load(NextDispatcher next, LoadNotificationsAction action, Wrapper wrapper,
    Store<AppState> store) async {
  next(action);
  final data = await wrapper.post("api/notification/unread");

  if (data != null) {
    store.dispatch(NotificationsLoadedAction(
        List<Map<String, dynamic>>.from(data)
            .map((n) => Notification.parse(n))
            .toList()));
  }
}

void _delete(Wrapper wrapper, Store<AppState> store, NextDispatcher next,
    DeleteNotificationAction action) async {
  if (await wrapper.noInternet) {
    store.dispatch(NoInternetAction(true));
    return;
  }
  next(action);

  wrapper.post(
      "api/notification/markAsRead", {"id": action.notification.id}, false);
}

void _deleteAll(Wrapper wrapper, Store<AppState> store, NextDispatcher next,
    DeleteAllNotificationsAction action) async {
  if (await wrapper.noInternet) {
    store.dispatch(NoInternetAction(true));
    return;
  }
  next(action);
  wrapper.post("api/notification/markAsRead", {}, false);
}
