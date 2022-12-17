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

library app_state;

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'package:dr/data.dart';
import 'package:dr/utc_date_time.dart';

part 'app_state.g.dart';

bool isDemoUser({required String? url, required String? username}) {
  return username == "demo-user-6540" &&
      url == "https://vinzentinum.digitalesregister.it";
}

abstract class AppState implements Built<AppState, AppStateBuilder> {
  DashboardState get dashboardState;
  @BuiltValueField(serialize: false)
  LoginState get loginState;
  NotificationState get notificationState;
  GradesState get gradesState;

  AbsencesState get absencesState;

  @BuiltValueField(serialize: false)
  Config? get config;
  @BuiltValueField(serialize: false)
  bool get noInternet;

  SettingsState get settingsState;

  ProfileState get profileState;
  CalendarState get calendarState;
  CertificateState get certificateState;

  MessagesState get messagesState;

  @BuiltValueField(serialize: false)
  NetworkProtocolState get networkProtocolState;

  @BuiltValueField(serialize: false)
  String? get url;
  static Serializer<AppState> get serializer => _$appStateSerializer;

  bool get isDemo => isDemoUser(url: url, username: loginState.username);

  List<String> extractAllSubjects() {
    final subjects = <String>{};
    for (final day in calendarState.days.values) {
      for (final hour in day.hours) {
        subjects.add(hour.subject);
      }
    }
    for (final subject in gradesState.subjects) {
      subjects.add(subject.name);
    }
    if (dashboardState.allDays != null) {
      for (final day in dashboardState.allDays!) {
        for (final homework in day.homework) {
          if (homework.label != null) subjects.add(homework.label!);
        }
      }
    }
    return subjects.toList();
  }

  factory AppState([Function(AppStateBuilder b)? updates]) = _$AppState;
  AppState._();
  static void _initializeBuilder(AppStateBuilder builder) {
    builder
      ..dashboardState = DashboardStateBuilder()
      ..loginState = LoginStateBuilder()
      ..notificationState = NotificationStateBuilder()
      ..gradesState = GradesStateBuilder()
      ..calendarState = CalendarStateBuilder()
      ..settingsState = SettingsStateBuilder()
      ..certificateState = CertificateStateBuilder()
      ..absencesState = AbsencesStateBuilder()
      ..messagesState = MessagesStateBuilder()
      ..profileState = ProfileStateBuilder()
      ..networkProtocolState = NetworkProtocolStateBuilder()
      ..noInternet = false;
  }
}

abstract class MessagesState
    implements Built<MessagesState, MessagesStateBuilder> {
  BuiltList<Message> get messages;

  int? get showMessage;

  UtcDateTime? get lastFetched;

  static Serializer<MessagesState> get serializer => _$messagesStateSerializer;

  factory MessagesState([Function(MessagesStateBuilder b)? updates]) =
      _$MessagesState;
  MessagesState._();

  static void _initializeBuilder(MessagesStateBuilder builder) {
    builder.messages = ListBuilder();
  }
}

abstract class DashboardState
    implements Built<DashboardState, DashboardStateBuilder> {
  @BuiltValueField(serialize: false)
  bool get loading;
  bool get future;

  BuiltList<HomeworkType>? get blacklist;

  BuiltList<Day>? get allDays;
  static Serializer<DashboardState> get serializer =>
      _$dashboardStateSerializer;

  factory DashboardState([Function(DashboardStateBuilder b)? updates]) =
      _$DashboardState;
  DashboardState._();
  static void _initializeBuilder(DashboardStateBuilder builder) {
    builder
      ..future = true
      ..loading = false
      ..blacklist = ListBuilder();
  }
}

abstract class LoginState implements Built<LoginState, LoginStateBuilder> {
  bool get loggedIn;
  bool get loading;

  String? get errorMsg;

  String? get username;
  bool get changePassword;
  bool get mustChangePassword;
  BuiltList<void Function()> get callAfterLogin;
  BuiltList<String> get otherAccounts;
  ResetPassState get resetPassState;
  factory LoginState([Function(LoginStateBuilder b)? updates]) = _$LoginState;
  LoginState._();
  static void _initializeBuilder(LoginStateBuilder builder) {
    builder
      ..loggedIn = false
      ..loading = false
      ..changePassword = false
      ..mustChangePassword = true
      ..callAfterLogin = ListBuilder()
      ..resetPassState = ResetPassStateBuilder()
      ..otherAccounts = ListBuilder();
  }
}

abstract class ResetPassState
    implements Built<ResetPassState, ResetPassStateBuilder> {
  String? get message;
  bool get failure;

  String? get token;

  String? get email;

  String? get username;
  factory ResetPassState([Function(ResetPassStateBuilder b)? updates]) =
      _$ResetPassState;
  ResetPassState._();
  static void _initializeBuilder(ResetPassStateBuilder builder) {
    builder.failure = false;
  }
}

abstract class NotificationState
    implements Built<NotificationState, NotificationStateBuilder> {
  BuiltList<Notification>? get notifications;
  UtcDateTime? get lastFetched;

  bool get loading => notifications == null;
  bool get hasNotifications => !loading && notifications!.isNotEmpty;
  static Serializer<NotificationState> get serializer =>
      _$notificationStateSerializer;

  factory NotificationState([Function(NotificationStateBuilder b)? updates]) =
      _$NotificationState;
  // ignore: prefer_const_constructors_in_immutables
  NotificationState._();
}

abstract class Config implements Built<Config, ConfigBuilder> {
  int get userId;
  int get autoLogoutSeconds;
  String get fullName;
  String get imgSource;

  int? get currentSemesterMaybe;
  bool get isStudentOrParent;
  static Serializer<Config> get serializer => _$configSerializer;

  factory Config([Function(ConfigBuilder b)? updates]) = _$Config;
  // ignore: prefer_const_constructors_in_immutables
  Config._();
}

abstract class GradesState implements Built<GradesState, GradesStateBuilder> {
  @BuiltValueField(serialize: false)
  bool get loading;
  bool get hasGrades => subjects.isNotEmpty;
  Semester get semester;
  BuiltList<Subject> get subjects;

  /// If unknown: null

  @BuiltValueField(serialize: false)
  Semester? get serverSemester;

  static Serializer<GradesState> get serializer => _$gradesStateSerializer;

  factory GradesState([Function(GradesStateBuilder b)? updates]) =
      _$GradesState;
  GradesState._();
  static void _initializeBuilder(GradesStateBuilder builder) {
    builder
      ..semester = Semester.all.toBuilder()
      ..subjects = ListBuilder()
      ..loading = false;
  }
}

abstract class SubjectTheme
    implements Built<SubjectTheme, SubjectThemeBuilder> {
  int get thick;
  int get color;

  static Serializer<SubjectTheme> get serializer => _$subjectThemeSerializer;

  factory SubjectTheme([Function(SubjectThemeBuilder b)? updates]) =
      _$SubjectTheme;
  SubjectTheme._();
}

abstract class Semester implements Built<Semester, SemesterBuilder> {
  String get name;

  int? get n;
  static final first = _$Semester((b) => b
    ..name = "1. Semester"
    ..n = 1);
  static final second = _$Semester((b) => b
    ..name = "2. Semester"
    ..n = 2);
  static final all = _$Semester((b) => b..name = "Beide Semester");
  static final values = [first, second, all];
  static Serializer<Semester> get serializer => _$semesterSerializer;
  factory Semester([void Function(SemesterBuilder)? updates]) = _$Semester;
  Semester._();
}

abstract class SettingsState
    implements Built<SettingsState, SettingsStateBuilder> {
  bool get noPasswordSaving;
  bool get noDataSaving;

  /// true = sort grades inside subjects by type;
  ///
  /// false = sort grades inside subjects by date
  bool get typeSorted;
  bool get askWhenDelete;
  bool get showCancelled;
  bool get deleteDataOnLogout;
  BuiltMap<String, String> get subjectNicks;

  // This is not a setting, but relevant for the UI behavior
  // of the settings page and is therefore not serialized
  @BuiltValueField(serialize: false)
  bool get scrollToSubjectNicks;
  @BuiltValueField(serialize: false)
  bool get scrollToGrades;
  bool get showCalendarNicksBar;
  bool get showGradesDiagram;
  bool get showAllSubjectsAverage;
  bool get dashboardMarkNewOrChangedEntries;
  bool get dashboardDeduplicateEntries;

  // whether to color the borders of items in the color specified by subjectThemes
  bool get dashboardColorBorders;
  bool get dashboardColorTestsInRed;
  BuiltMap<String, SubjectTheme> get subjectThemes;
  BuiltList<String> get ignoreForGradesAverage;

  // Whether to fully expand the drawer if in tablet mode
  // if not, only the icons are shown
  bool get drawerFullyExpanded;

  factory SettingsState([Function(SettingsStateBuilder b)? updates]) =
      _$SettingsState;
  SettingsState._();
  static Serializer<SettingsState> get serializer => _$settingsStateSerializer;
  static void _initializeBuilder(SettingsStateBuilder builder) {
    builder
      ..noPasswordSaving = false
      ..noDataSaving = false
      ..typeSorted = false
      ..askWhenDelete = false
      ..showCancelled = false
      ..deleteDataOnLogout = false
      ..subjectNicks = MapBuilder<String, String>(const {
        "Deutsch": "Deu",
        "Mathematik": "Mat",
        "Latein": "Lat",
        "Religion": "Rel",
        "Englisch": "Eng",
        "Naturwissenschaften": "Nat",
        "Geschichte": "Gesch",
        "Italienisch": "Ita",
        "Bewegung und Sport": "Sport",
        "Recht und Wirtschaft": "Rw",
        "Griechisch": "Gr",
        "FÜ": "Fü",
      })
      ..showCalendarNicksBar = true
      ..showGradesDiagram = true
      ..showAllSubjectsAverage = true
      ..dashboardMarkNewOrChangedEntries = true
      ..dashboardDeduplicateEntries = true
      ..subjectThemes = MapBuilder<String, SubjectTheme>()
      ..drawerFullyExpanded = true
      ..ignoreForGradesAverage = ListBuilder()
      ..dashboardColorBorders = false
      ..dashboardColorTestsInRed = true
      ..scrollToGrades = false
      ..scrollToSubjectNicks = false;
  }
}

abstract class ProfileState
    implements Built<ProfileState, ProfileStateBuilder> {
  factory ProfileState([Function(ProfileStateBuilder b)? updates]) =
      _$ProfileState;
  ProfileState._();
  static Serializer<ProfileState> get serializer => _$profileStateSerializer;

  String? get email;
  String? get username;
  String? get roleName;
  String? get name;
  bool? get sendNotificationEmails;
}

abstract class AbsencesState
    implements Built<AbsencesState, AbsencesStateBuilder> {
  factory AbsencesState([Function(AbsencesStateBuilder b)? updates]) =
      _$AbsencesState;
  AbsencesState._();
  static Serializer<AbsencesState> get serializer => _$absencesStateSerializer;

  AbsenceStatistic? get statistic;
  BuiltList<AbsenceGroup> get absences;
  BuiltList<FutureAbsence> get futureAbsences;

  UtcDateTime? get lastFetched;

  static void _initializeBuilder(AbsencesStateBuilder builder) {
    builder
      ..absences = ListBuilder<AbsenceGroup>()
      ..futureAbsences = ListBuilder<FutureAbsence>();
  }
}

abstract class CalendarState
    implements Built<CalendarState, CalendarStateBuilder> {
  BuiltMap<UtcDateTime, CalendarDay> get days;

  @BuiltValueField(serialize: false)
  UtcDateTime? get currentMonday;
  @BuiltValueField(serialize: false)
  CalendarSelection? get selection;

  Iterable<CalendarDay> get currentDays {
    return daysForWeek(currentMonday!);
  }

  Iterable<CalendarDay> daysForWeek(UtcDateTime monday) {
    return days.values.where((d) {
      final date = UtcDateTime(d.date.year, d.date.month, d.date.day);
      return !date.isBefore(monday) &&
          date.isBefore(monday.add(const Duration(days: 7)));
    });
  }

  factory CalendarState([Function(CalendarStateBuilder b)? updates]) =
      _$CalendarState;
  CalendarState._();
  static Serializer<CalendarState> get serializer => _$calendarStateSerializer;
  static void _initializeBuilder(CalendarStateBuilder builder) {
    builder.days = MapBuilder<UtcDateTime, CalendarDay>();
  }
}

abstract class CalendarSelection
    implements Built<CalendarSelection, CalendarSelectionBuilder> {
  UtcDateTime get date;
  int? get hour;

  factory CalendarSelection([Function(CalendarSelectionBuilder b)? updates]) =
      _$CalendarSelection;
  CalendarSelection._();
  static Serializer<CalendarSelection> get serializer =>
      _$calendarSelectionSerializer;
}

abstract class CertificateState
    implements Built<CertificateState, CertificateStateBuilder> {
  String? get html;
  UtcDateTime? get lastFetched;

  factory CertificateState([void Function(CertificateStateBuilder)? updates]) =
      _$CertificateState;
  CertificateState._();
  static Serializer<CertificateState> get serializer =>
      _$certificateStateSerializer;
}

abstract class NetworkProtocolState
    implements Built<NetworkProtocolState, NetworkProtocolStateBuilder> {
  BuiltList<NetworkProtocolItem> get items;

  factory NetworkProtocolState(
          [Function(NetworkProtocolStateBuilder b)? updates]) =
      _$NetworkProtocolState;
  NetworkProtocolState._();

  static void _initializeBuilder(NetworkProtocolStateBuilder builder) {
    builder.items = ListBuilder();
  }
}

abstract class NetworkProtocolItem
    implements Built<NetworkProtocolItem, NetworkProtocolItemBuilder> {
  String get address;
  String get parameters;
  String get response;

  factory NetworkProtocolItem(
          [Function(NetworkProtocolItemBuilder b)? updates]) =
      _$NetworkProtocolItem;
  NetworkProtocolItem._();
}
