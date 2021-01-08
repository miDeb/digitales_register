part of 'middleware.dart';

final _dashboardMiddleware = MiddlewareBuilder<AppState, AppStateBuilder,
    AppActions>()
  ..add(DashboardActionsNames.load, _loadDays)
  ..add(DashboardActionsNames.switchFuture, _switchFuture)
  ..add(DashboardActionsNames.addReminder, _addReminder)
  ..add(DashboardActionsNames.deleteHomework, _deleteHomework)
  ..add(DashboardActionsNames.toggleDone, _toggleDone)
  ..add(SettingsActionsNames.markNotSeenDashboardEntries, _markNotSeenEntries);

void _loadDays(MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next, Action<bool> action) async {
  if (api.state.noInternet) return;

  next(action);
  final data = await _wrapper.send("/api/student/dashboard/dashboard",
      args: {"viewFuture": action.payload});

  if (data is! List) {
    api.actions.refreshNoInternet();
    api.actions.dashboardActions.notLoaded();
    return;
  }
  api.actions.dashboardActions.loaded(
    DaysLoadedPayload(
      (b) => b
        ..data = data
        ..future = action.payload
        ..markNewOrChangedEntries =
            api.state.settingsState.dashboardMarkNewOrChangedEntries
        ..deduplicateEntries =
            api.state.settingsState.dashboardDeduplicateEntries,
    ),
  );
}

void _switchFuture(MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next, Action<void> action) {
  next(action);
  api.actions.dashboardActions.load(api.state.dashboardState.future);
}

void _addReminder(MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next, Action<AddReminderPayload> action) async {
  next(action);
  final result = await _wrapper.send(
    "/api/student/dashboard/save_reminder",
    args: {
      "date": DateFormat("yyyy-MM-dd").format(action.payload.date),
      "text": action.payload.msg,
    },
  );
  if (result == null) {
    showSnackBar("Beim Speichern ist ein Fehler aufgetreten");
    api.actions.refreshNoInternet();
    return;
  }
  api.actions.dashboardActions.homeworkAdded(
    HomeworkAddedPayload(
      (b) => b
        ..data = result
        ..date = action.payload.date,
    ),
  );
}

void _deleteHomework(MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next, Action<Homework> action) async {
  final result = await _wrapper.send(
    "/api/student/dashboard/delete_reminder",
    args: {
      "id": action.payload.id,
    },
  );
  if (result != null && result["success"]) {
    next(action);
  } else {
    showSnackBar("Beim Speichern ist ein Fehler aufgetreten");
    api.actions.refreshNoInternet();
    return;
  }
}

void _toggleDone(MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next, Action<ToggleDonePayload> action) async {
  next(action);
  final result = await _wrapper.send(
    "/api/student/dashboard/toggle_reminder",
    args: {
      "id": action.payload.hw.id,
      "type": action.payload.hw.type.name,
      "value": action.payload.done,
    },
  );
  if (result != null && result["success"]) {
    // duplicate - protection from multiple, failing and not failing requests
    next(action);
  } else {
    next(
      Action(
        DashboardActionsNames.toggleDone.name,
        ToggleDonePayload(
          (b) => b
            ..hw = action.payload.hw.toBuilder()
            ..done = !action.payload.hw.checked,
        ),
      ),
    );
    showSnackBar("Beim Speichern ist ein Fehler aufgetreten");
    api.actions.refreshNoInternet();
    return;
  }
}

void _markNotSeenEntries(
    MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next,
    Action<bool> action) {
  if (!action.payload) {
    api.actions.dashboardActions.markAllAsSeen();
  }
  next(action);
}
