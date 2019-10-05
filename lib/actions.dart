import 'package:built_collection/built_collection.dart';

import 'app_state.dart';
import 'data.dart';

class ErrorAction{
  final Error e;

  ErrorAction(this.e);
}

class DaysLoadedAction {
  final ListBuilder<Day> loadedDays;
  final bool future;

  DaysLoadedAction(this.loadedDays, this.future);
  @override
  String toString() {
    return "DaysLoadedAction(loadedDays: $loadedDays";
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
  final String user, pass;

  final bool fromStorage;
  final bool offlineEnabled;

  LoginAction(this.user, this.pass, this.fromStorage,
      [this.offlineEnabled = false])
      : assert(!offlineEnabled || fromStorage);
  @override
  String toString() {
    return "LoginAction(user: $user, pass: ..., fromStorage: $fromStorage";
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

abstract class SettingsAction {}

class SetSaveNoPassAction implements SettingsAction {
  final bool noSave;

  SetSaveNoPassAction(this.noSave);
  @override
  String toString() {
    return "SetSaveNoPassAction(safeMode: $noSave)";
  }
}

/// Immediately save state!
class SaveStateAction{}

class SetOfflineEnabledAction implements SettingsAction {
  final bool enable;

  SetOfflineEnabledAction(this.enable);
  @override
  String toString() {
    return "SetEnableOfflineAction(enable: $enable)";
  }
}

class SetSaveNoDataAction implements SettingsAction {
  final bool noSave;

  SetSaveNoDataAction(this.noSave);
  @override
  String toString() {
    return "SetSaveNoDataAction(safeMode: $noSave)";
  }
}

class SetDeleteDataOnLogoutAction implements SettingsAction {
  final bool delete;

  SetDeleteDataOnLogoutAction(this.delete);
  @override
  String toString() {
    return "SetDeleteDataOnLogoutAction(safeMode: $delete)";
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
  final ListBuilder<Notification> notifications;

  NotificationsLoadedAction(this.notifications);
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

class LoadSubjectsAction {}

class LoadSubjectDetailsAction {
  final AllSemesterSubject subject;

  LoadSubjectDetailsAction(this.subject);
}

class SubjectsLoadedAction {
  final ListBuilder<AllSemesterSubject> subjects;
  final int lastRequestedSemester;

  SubjectsLoadedAction(this.subjects, this.lastRequestedSemester);
}

class SetGraphConfigsAction {
  final Map<int, SubjectGraphConfig> configs;

  SetGraphConfigsAction(this.configs);
}

class ShowFullscreenChartAciton {}

class ShowGradesAction {}

class SetIsDarkMode {
  final bool darkMode;

  SetIsDarkMode(this.darkMode);
}

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
  final Homework hw;
  final DateTime date;

  HomeworkAddedAction(this.hw, this.date);
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

class MarkAsNotNewOrChangedAction{
  final Homework homework;

  MarkAsNotNewOrChangedAction(this.homework);
}

class MarkAllAsNotNewOrChangedAction{

  MarkAllAsNotNewOrChangedAction();
}

class SetAskWhenDeleteAction implements SettingsAction {
  final bool ask;

  SetAskWhenDeleteAction(this.ask);
}

class SetNoAverageForAllAction implements SettingsAction {
  final bool noAvg;

  SetNoAverageForAllAction(this.noAvg);
}

class SetDoubleTapForDoneAction implements SettingsAction {
  final bool enabled;

  SetDoubleTapForDoneAction(this.enabled);
}

class SetCalendarShowDatesAction implements SettingsAction {
  final bool showDates;

  SetCalendarShowDatesAction(this.showDates);
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

class AddNetworkProtocolItemAction{
  final NetworkProtocolItem item;

  AddNetworkProtocolItemAction(this.item);
}

class UpdateHomeworkFilterBlacklistAction{
  final List<HomeworkType> blacklist;

  UpdateHomeworkFilterBlacklistAction(this.blacklist);
}