import 'package:dr/linux.dart';
import 'package:intl/intl.dart';
import 'package:redux/redux.dart';

import '../actions.dart';
import '../app_state.dart';
import '../wrapper.dart';

List<Middleware<AppState>> daysMiddlewares(Wrapper wrapper) => [
      TypedMiddleware<AppState, LoadDaysAction>(
        (store, action, next) => _loadDays(next, action, wrapper, store),
      ),
      TypedMiddleware<AppState, DaysNotLoadedAction>(
        (store, action, next) => _daysNotLoaded(next, action, store),
      ),
      TypedMiddleware<AppState, SwitchFutureAction>(
        (store, action, next) => _switchFuture(next, action, store),
      ),
      TypedMiddleware<AppState, AddReminderAction>(
        (store, action, next) => _addReminder(store, action, next, wrapper),
      ),
      TypedMiddleware<AppState, DeleteHomeworkAction>(
        (store, action, next) => _deleteHomework(store, action, next, wrapper),
      ),
      TypedMiddleware<AppState, ToggleDoneAction>(
        (store, action, next) => _toggleDone(store, action, next, wrapper),
      ),
    ];

void _loadDays(NextDispatcher next, LoadDaysAction action, Wrapper wrapper,
    Store<AppState> store) async {
  next(action);
  final data = await wrapper
      .post("/api/student/dashboard/dashboard", {"viewFuture": action.future});
  if (data == null) {
    store.dispatch(
      await wrapper.noInternet
          ? DaysNotLoadedAction.noInternet()
          : DaysNotLoadedAction(wrapper.error),
    );
  } else {
    store.dispatch(
      DaysLoadedAction(
        data,
        action.future,
        store.state.settingsState.dashboardMarkNewOrChangedEntries,
      ),
    );
  }
}

void _daysNotLoaded(void next(dynamic action), DaysNotLoadedAction action,
    Store<AppState> store) {
  next(action);
  if (action.noInternet) store.dispatch(NoInternetAction(true));
}

void _switchFuture(
    NextDispatcher next, SwitchFutureAction action, Store<AppState> store) {
  next(action);
  store.dispatch(LoadDaysAction(store.state.dayState.future));
}

void _addReminder(Store<AppState> store, AddReminderAction action, next,
    Wrapper wrapper) async {
  next(action);

  final result = await wrapper.post("/api/student/dashboard/save_reminder", {
    "date": DateFormat("yyyy-MM-dd").format(action.date),
    "text": action.msg,
  });
  if (result == null) {
    if (await wrapper.noInternet) {
      store.dispatch(NoInternetAction(true));
      return;
    }
    showToast(msg: "Beim Speichern ist ein Fehler aufgetreten");
    return;
  }
  store.dispatch(
    HomeworkAddedAction(
      result,
      action.date,
    ),
  );
}

void _deleteHomework(Store<AppState> store, DeleteHomeworkAction action, next,
    Wrapper wrapper) async {
  next(action);

  final result = await wrapper.post("/api/student/dashboard/delete_reminder", {
    "id": action.hw.id,
  });
  if (result != null && result["success"]) {
    // already called next
  } else {
    next(HomeworkAddedAction(action.hw, action.date));
    if (await wrapper.noInternet) {
      store.dispatch(NoInternetAction(true));
      return;
    }
    showToast(msg: "Beim Speichern ist ein Fehler aufgetreten");
    return;
  }
}

void _toggleDone(Store<AppState> store, ToggleDoneAction action, next,
    Wrapper wrapper) async {
  next(action);
  final result = await wrapper.post("/api/student/dashboard/toggle_reminder", {
    "id": action.hw.id,
    "type": action.hw.type.name,
    "value": action.done,
  });
  if (result != null && result["success"]) {
    next(
        action); // duplicate - protection from multiple, failing and not failing requests
  } else {
    next(ToggleDoneAction(action.hw, !action.hw.checked));
    if (await wrapper.noInternet) {
      store.dispatch(NoInternetAction(true));
      return;
    }
    showToast(msg: "Beim Speichern ist ein Fehler aufgetreten");
    return;
  }
}
