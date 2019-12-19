import 'package:intl/intl.dart';
import 'package:redux/redux.dart';

import '../actions/app_actions.dart';
import '../actions/dashboard_actions.dart';
import '../app_state.dart';
import '../linux.dart';
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
          ? DaysNotLoadedAction((b) => b..noInternet = true)
          : DaysNotLoadedAction((b) => b..errorMsg = wrapper.error),
    );
  } else {
    if (data is! List) {
      // TODO: Handle unexpected response
      return;
    }
    store.dispatch(
      DaysLoadedAction(
        (b) => b
          ..data = data
          ..future = action.future
          ..markNewOrChangedEntries =
              store.state.settingsState.dashboardMarkNewOrChangedEntries,
      ),
    );
  }
}

void _daysNotLoaded(void next(dynamic action), DaysNotLoadedAction action,
    Store<AppState> store) {
  next(action);
  if (action.noInternet)
    store.dispatch(
      NoInternetAction(
        (b) => b..noInternet = true,
      ),
    );
}

void _switchFuture(
    NextDispatcher next, SwitchFutureAction action, Store<AppState> store) {
  next(action);
  store.dispatch(
    LoadDaysAction(
      (b) => b..future = store.state.dayState.future,
    ),
  );
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
      store.dispatch(
        NoInternetAction(
          (b) => b..noInternet = true,
        ),
      );
      return;
    }
    showToast(msg: "Beim Speichern ist ein Fehler aufgetreten");
    return;
  }
  store.dispatch(
    HomeworkAddedAction(
      (b) => b
        ..data = result
        ..date = action.date,
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
    next(
      HomeworkAddedAction(
        (b) => b
          ..data = action.hw
          ..date = action.date,
      ),
    );
    if (await wrapper.noInternet) {
      store.dispatch(
        NoInternetAction(
          (b) => b..noInternet = true,
        ),
      );
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
    next(
      ToggleDoneAction(
        (b) => b
          ..hw = action.hw.toBuilder()
          ..done = !action.hw.checked,
      ),
    );
    if (await wrapper.noInternet) {
      store.dispatch(
        NoInternetAction(
          (b) => b..noInternet = true,
        ),
      );
      return;
    }
    showToast(msg: "Beim Speichern ist ein Fehler aufgetreten");
    return;
  }
}
