import 'package:redux/redux.dart';

import '../actions/app_actions.dart';
import '../actions/notifications_actions.dart';
import '../app_state.dart';
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
  final data = await wrapper.post("/api/notification/unread");

  if (data != null) {
    store.dispatch(
      NotificationsLoadedAction(
        (b) => b..data = data,
      ),
    );
  }
}

void _delete(Wrapper wrapper, Store<AppState> store, NextDispatcher next,
    DeleteNotificationAction action) async {
  if (await wrapper.noInternet) {
    store.dispatch(
      NoInternetAction(
        (b) => b..noInternet = true,
      ),
    );
    return;
  }
  next(action);

  wrapper.post(
      "/api/notification/markAsRead", {"id": action.notification.id}, false);
}

void _deleteAll(Wrapper wrapper, Store<AppState> store, NextDispatcher next,
    DeleteAllNotificationsAction action) async {
  if (await wrapper.noInternet) {
    store.dispatch(
      NoInternetAction(
        (b) => b..noInternet = true,
      ),
    );
    return;
  }
  next(action);
  wrapper.post("/api/notification/markAsRead", {}, false);
}
