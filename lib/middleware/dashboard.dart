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

final _dashboardMiddleware = MiddlewareBuilder<AppState, AppStateBuilder,
    AppActions>()
  ..add(DashboardActionsNames.load, _loadDays)
  ..add(DashboardActionsNames.switchFuture, _switchFuture)
  ..add(DashboardActionsNames.addReminder, _addReminder)
  ..add(DashboardActionsNames.deleteHomework, _deleteHomework)
  ..add(DashboardActionsNames.toggleDone, _toggleDone)
  ..add(DashboardActionsNames.openAttachment, _openAttachment)
  ..add(SettingsActionsNames.markNotSeenDashboardEntries, _markNotSeenEntries);

Future<void> _loadDays(MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next, Action<bool> action) async {
  if (api.state.noInternet) return;

  await next(action);
  final dynamic data = await wrapper.send("api/student/dashboard/dashboard",
      args: {"viewFuture": action.payload});

  if (data is! List) {
    await api.actions.dashboardActions.notLoaded();
    return;
  }
  await api.actions.dashboardActions.loaded(
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
  await api.actions.dashboardActions.load(api.state.dashboardState.future);
}

Future<void> _addReminder(
    MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next,
    Action<AddReminderPayload> action) async {
  await next(action);
  final dynamic result = await wrapper.send(
    "api/student/dashboard/save_reminder",
    args: {
      "date": DateFormat("yyyy-MM-dd").format(action.payload.date),
      "text": action.payload.msg,
    },
  );
  if (result == null && !wrapper.noInternet) {
    showSnackBar("Beim Speichern ist ein Fehler aufgetreten");
    return;
  }
  await api.actions.dashboardActions.homeworkAdded(
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
  final dynamic result = await wrapper.send(
    "api/student/dashboard/delete_reminder",
    args: {
      "id": action.payload.id,
    },
  );
  if (result != null && result["success"] == true) {
    await next(action);
  } else if (!wrapper.noInternet) {
    showSnackBar("Beim Speichern ist ein Fehler aufgetreten");
  }
}

Future<void> _toggleDone(
    MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next,
    Action<ToggleDonePayload> action) async {
  await next(action);
  final dynamic result = await wrapper.send(
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
    if (!wrapper.noInternet) {
      showSnackBar("Beim Speichern ist ein Fehler aufgetreten");
    }
  }
}

Future<void> _markNotSeenEntries(
    MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next,
    Action<bool> action) async {
  if (!action.payload) {
    await api.actions.dashboardActions.markAllAsSeen();
  }
  await next(action);
}

Future<void> _openAttachment(
    MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
    ActionHandler next,
    Action<GradeGroupSubmission> action) async {
  await next(action);

  if (!action.payload.fileAvailable ||
      !await canOpenFile(action.payload.uniqueName)) {
    await api.actions.dashboardActions.downloadAttachment(action.payload);

    await next(action);
    final success = await downloadFile(
      "${wrapper.baseAddress}api/gradeGroup/gradeGroupSubmissionDownloadEntry",
      action.payload.uniqueName,
      <String, dynamic>{
        "submissionId": action.payload.id,
        "parentId": action.payload.gradeGroupId,
      },
    );
    if (success) {
      await api.actions.dashboardActions.attachmentReady(action.payload);
    }
  }

  await openFile(action.payload.uniqueName);
}
