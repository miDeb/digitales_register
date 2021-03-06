part of 'middleware.dart';

final _dashboardMiddleware = MiddlewareBuilder<AppState, AppStateBuilder,
    AppActions>()
  ..add(DashboardActionsNames.load, _loadDays)
  ..add(DashboardActionsNames.switchFuture, _switchFuture)
  ..add(DashboardActionsNames.addReminder, _addReminder)
  ..add(DashboardActionsNames.deleteHomework, _deleteHomework)
  ..add(DashboardActionsNames.toggleDone, _toggleDone)
  ..add(DashboardActionsNames.downloadAttachment, _downloadAttachment)
  ..add(DashboardActionsNames.openAttachment, _openAttachment)
  ..add(SettingsActionsNames.markNotSeenDashboardEntries, _markNotSeenEntries);

Future<void> _loadDays(MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next, Action<bool> action) async {
  if (api.state.noInternet) return;

  await next(action);
  final dynamic data = await _wrapper.send("api/student/dashboard/dashboard",
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

Future<void> _switchFuture(
    MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next,
    Action<void> action) async {
  await next(action);
  api.actions.dashboardActions.load(api.state.dashboardState.future);
}

Future<void> _addReminder(
    MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next,
    Action<AddReminderPayload> action) async {
  await next(action);
  final dynamic result = await _wrapper.send(
    "api/student/dashboard/save_reminder",
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

Future<void> _deleteHomework(
    MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next,
    Action<Homework> action) async {
  final dynamic result = await _wrapper.send(
    "api/student/dashboard/delete_reminder",
    args: {
      "id": action.payload.id,
    },
  );
  if (result != null && result["success"] == true) {
    await next(action);
  } else {
    showSnackBar("Beim Speichern ist ein Fehler aufgetreten");
    api.actions.refreshNoInternet();
    return;
  }
}

Future<void> _toggleDone(
    MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next,
    Action<ToggleDonePayload> action) async {
  await next(action);
  final dynamic result = await _wrapper.send(
    "api/student/dashboard/toggle_reminder",
    args: {
      "id": action.payload.homeworkId,
      "type": action.payload.type,
      "value": action.payload.done,
    },
  );
  if (result != null && result["success"] == true) {
    // duplicate - protection from multiple, failing and not failing requests
    // TODO: Does this even work??
    await next(action);
  } else {
    await next(
      Action<ToggleDonePayload>(
        DashboardActionsNames.toggleDone.name,
        ToggleDonePayload(
          (b) => b
            ..homeworkId = action.payload.homeworkId
            ..type = action.payload.type
            ..done = !action.payload.done,
        ),
      ),
    );
    showSnackBar("Beim Speichern ist ein Fehler aufgetreten");
    api.actions.refreshNoInternet();
  }
}

Future<void> _markNotSeenEntries(
    MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next,
    Action<bool> action) async {
  if (!action.payload) {
    api.actions.dashboardActions.markAllAsSeen();
  }
  await next(action);
}

Future<void> _downloadAttachment(
    MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next,
    Action<GradeGroupSubmission> action) async {
  if (api.state.noInternet) return;
  await next(action);
  final saveFile = File(
    "${(await getApplicationDocumentsDirectory()).path}/${action.payload.originalName}",
  );

  final result = await _wrapper.dio.get<dynamic>(
    "${_wrapper.baseAddress}api/gradeGroup/gradeGroupSubmissionDownloadEntry",
    queryParameters: <String, dynamic>{
      "submissionId": action.payload.id,
      "parentId": action.payload.gradeGroupId,
    },
    options: dio.Options(responseType: dio.ResponseType.stream),
  );
  final sink = saveFile.openWrite();
  await sink.addStream((result.data as dio.ResponseBody).stream);
  await sink.flush();
  await sink.close();
  if (result.statusCode == 200) {
    showSnackBar("Heruntergeladen");
    api.actions.dashboardActions.attachmentReady(action.payload);
  }
}

Future<void> _openAttachment(
    MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next,
    Action<GradeGroupSubmission> action) async {
  await next(action);
  final saveFile = File(
      "${(await getApplicationDocumentsDirectory()).path}/${action.payload.originalName}");
  await OpenFile.open(saveFile.path);
}
