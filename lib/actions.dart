import 'app_state.dart';
import 'data.dart';

class ErrorAction {
  final Error e;

  ErrorAction(this.e);
}

class DaysLoadedAction {
  final dynamic data;
  final bool future, markNewOrChangedEntries;

  DaysLoadedAction(this.data, this.future, this.markNewOrChangedEntries);
  @override
  String toString() {
    return "DaysLoadedAction(data: $data)";
  }
}

class DaysNotLoadedAction {
  final String errorMsg;
  final bool noInternet;

  DaysNotLoadedAction(this.errorMsg) : noInternet = false;
  DaysNotLoadedAction.noInternet()
      : errorMsg = null,
        noInternet = true;
  @override
  String toString() {
    return "DaysNotLoadedAction(errorMsg : $errorMsg, noInternet: $noInternet)";
  }
}

class LoadDaysAction {
  final bool future;

  LoadDaysAction(this.future);
}

class SwitchFutureAction {}

class LoginAction {
  final String user, pass, url;

  final bool fromStorage;
  final bool offlineEnabled;

  LoginAction(this.user, this.pass, this.url, this.fromStorage,
      [this.offlineEnabled = false])
      : assert(!offlineEnabled || fromStorage);
  @override
  String toString() {
    return "LoginAction(user: $user, pass: ..., fromStorage: $fromStorage)";
  }
}

class LoggedInAction {
  final String userName;
  final bool fromStorage;

  LoggedInAction(this.userName, this.fromStorage);
  @override
  String toString() {
    return "LoggedInAction(userName: $userName, fromStorage: $fromStorage)";
  }
}

class LoginFailedAction {
  final String cause, username;

  final bool offlineEnabled, noInternet;

  LoginFailedAction(
      this.cause, this.offlineEnabled, this.noInternet, this.username);
  @override
  String toString() {
    return "LoginFailedAction(fromStorage: $offlineEnabled, noInternet: $noInternet)";
  }
}

class LogoutAction {
  final bool hard, forced;

  LogoutAction(this.hard, this.forced);
}

/// Update logout action
class TapAction {
  @override
  String toString() {
    return "tap";
  }
}

class SetSaveNoPassAction {
  final bool noSave;

  SetSaveNoPassAction(this.noSave);
  @override
  String toString() {
    return "SetSaveNoPassAction(safeMode: $noSave)";
  }
}

/// Immediately save state!
class SaveStateAction {}

class SetOfflineEnabledAction {
  final bool enable;

  SetOfflineEnabledAction(this.enable);
  @override
  String toString() {
    return "SetEnableOfflineAction(enable: $enable)";
  }
}

class SetSaveNoDataAction {
  final bool noSave;

  SetSaveNoDataAction(this.noSave);
  @override
  String toString() {
    return "SetSaveNoDataAction(safeMode: $noSave)";
  }
}

class SetDeleteDataOnLogoutAction {
  final bool delete;

  SetDeleteDataOnLogoutAction(this.delete);
  @override
  String toString() {
    return "SetDeleteDataOnLogoutAction(safeMode: $delete)";
  }
}

class SetSubjectNicksAction {
  final Map<String, String> subjectNicks;

  SetSubjectNicksAction(this.subjectNicks);
  @override
  String toString() {
    return "SetSubjectNicksAction(subjectNicks: $subjectNicks)";
  }
}

class LoggingInAction {}

class ShowLoginAction {}

class ShowAbsencesAction {}

/// Dispatched at the start of the app to trigger load logic
class LoadAction {}

class RefreshNoInternetAction {}

class NoInternetAction {
  final bool noInternet;

  NoInternetAction(this.noInternet);

  @override
  String toString() {
    return "NoInternetAction(noInternet: $noInternet)";
  }
}

class NotificationsLoadedAction {
  final dynamic data;

  NotificationsLoadedAction(this.data);
}

class ShowNotificationsAction {}

class ShowSettingsAction {}

class DeleteNotificationAction {
  final Notification notification;

  DeleteNotificationAction(this.notification);
}

class DeleteAllNotificationsAction {}

class LoadNotificationsAction {}

class RefreshAction {}

class SavePassAction {}

class DeletePassAction {}

class DeleteDataAction {}

class SetIsLoginRouteAction {
  final bool isLogin;

  SetIsLoginRouteAction(this.isLogin);
}

class SetConfigAction {
  final Config config;

  SetConfigAction(this.config);
}

class SetGradesSemesterAction {
  final Semester newSemester;

  SetGradesSemesterAction(this.newSemester);
}

class LoadSubjectsAction {
  final Semester semester;

  LoadSubjectsAction(this.semester);
}

class LoadSubjectDetailsAction {
  final Subject subject;
  final Semester semester;

  LoadSubjectDetailsAction(this.subject, this.semester);
}

class SubjectsLoadedAction {
  final dynamic data;
  final Semester semester;

  SubjectsLoadedAction(this.data, this.semester);
}

class UpdateGradesGraphConfigsAction {
  final List<Subject> subjects;

  UpdateGradesGraphConfigsAction(this.subjects);
}

class SubjectLoadedAction {
  final dynamic data;
  final Subject subject;
  final Semester semester;

  SubjectLoadedAction(this.data, this.semester, this.subject);
}

class SetGraphConfigsAction {
  final Map<int, SubjectGraphConfig> configs;

  SetGraphConfigsAction(this.configs);
}

class ShowFullscreenChartAciton {}

class ShowGradesAction {}

class MountAppStateAction {
  final AppState appState;

  MountAppStateAction(this.appState);
}

class AddReminderAction {
  final String msg;
  final DateTime date;

  AddReminderAction(this.msg, this.date);
}

class HomeworkAddedAction {
  final dynamic data;
  final DateTime date;

  HomeworkAddedAction(this.data, this.date);
}

class DeleteHomeworkAction {
  final Homework hw;
  final DateTime date;

  DeleteHomeworkAction(this.hw, this.date) : assert(hw.deleteable);
}

class ToggleDoneAction {
  final Homework hw;
  final bool done;

  ToggleDoneAction(this.hw, this.done);
}

class MarkAsNotNewOrChangedAction {
  final Homework homework;

  MarkAsNotNewOrChangedAction(this.homework);
}

class MarkDeletedHomeworkAsSeenAction {
  final Day day;

  MarkDeletedHomeworkAsSeenAction(this.day);
}

class MarkAllAsNotNewOrChangedAction {
  MarkAllAsNotNewOrChangedAction();
}

class SetAskWhenDeleteAction {
  final bool ask;

  SetAskWhenDeleteAction(this.ask);
}

class SetGradesTypeSortedAction {
  final bool typeSorted;

  SetGradesTypeSortedAction(this.typeSorted);
}

class SetGradesShowCancelledAction {
  final bool showCancelled;

  SetGradesShowCancelledAction(this.showCancelled);
}

class AbsencesLoadedAction {
  final absences;

  AbsencesLoadedAction(this.absences);

  @override
  String toString() {
    return "AbsencesLoadedAction(absences: $absences)";
  }
}

class LoadAbsencesAction {}

class LoggedInAgainAutomatically {}

class LoadCalendarAction {
  final DateTime startDate;

  LoadCalendarAction(this.startDate);
}

class CalendarLoadedAction {
  final result;

  CalendarLoadedAction(this.result);
}

class ShowCalendarAction {}

class AddNetworkProtocolItemAction {
  final NetworkProtocolItem item;

  AddNetworkProtocolItemAction(this.item);
}

class UpdateHomeworkFilterBlacklistAction {
  final List<HomeworkType> blacklist;

  UpdateHomeworkFilterBlacklistAction(this.blacklist);
}

class ShowEditCalendarSubjectNicksAction {}

class SetShowCalendarSubjectNicksBarAction {
  final bool show;

  SetShowCalendarSubjectNicksBarAction(this.show);
}

class SetShowGradesDiagramAction {
  final bool show;

  SetShowGradesDiagramAction(this.show);
}

class SetShowAllSubjectsAverageAction {
  final bool show;

  SetShowAllSubjectsAverageAction(this.show);
}

class SetDashboardMarkNewOrChangedEntriesAction {
  final bool mark;

  SetDashboardMarkNewOrChangedEntriesAction(this.mark);
}

class SetCalendarCurrentMondayAction {
  final DateTime monday;

  SetCalendarCurrentMondayAction(this.monday);
}
