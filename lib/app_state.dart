library app_state;

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:meta/meta.dart';

import 'data.dart';

part 'app_state.g.dart';

abstract class AppState implements Built<AppState, AppStateBuilder> {
  DayState get dayState;
  LoginState get loginState;
  NotificationState get notificationState;
  GradesState get gradesState;
  @nullable
  AbsenceState get absenceState;
  @nullable
  Config get config;
  bool get noInternet;
  bool get currentRouteIsLogin;
  @nullable
  SettingsState get settingsState;
  @nullable
  CalendarState get calendarState;
  @nullable
  NetworkProtocolState get networkProtocolState;
  static Serializer<AppState> get serializer => _$appStateSerializer;
  AppState._();
  factory AppState([updates(AppStateBuilder b)]) = _$AppState;
}

abstract class DayState implements Built<DayState, DayStateBuilder> {
  bool get loading;
  bool get future;
  @nullable
  BuiltList<HomeworkType> get blacklist;
  BuiltList<Day> get displayDays => allDays == null
      ? null
      : BuiltList(
          Day.filterFuture(allDays.toList(), future).map(
            (day) => Day(
                  date: day.date,
                  homework: day.homework.where(
                    (homework) => !blacklist.contains(homework.type),
                  ).toList(), 
                  deletedHomework: day.deletedHomework.where(
                    (deletedHomework) => !blacklist.contains(deletedHomework.type),
                  ).toList(), 
                ),
          ),
        );
  @nullable
  BuiltList<Day> get allDays;
  bool get hasDays => displayDays?.isNotEmpty == true;
  static Serializer<DayState> get serializer => _$dayStateSerializer;

  DayState._();
  factory DayState([updates(DayStateBuilder b)]) = _$DayState;
}

abstract class LoginState implements Built<LoginState, LoginStateBuilder> {
  bool get loggedIn;
  bool get loading;
  @nullable
  String get errorMsg;
  @nullable
  String get userName;
  static Serializer<LoginState> get serializer => _$loginStateSerializer;
  LoginState._();
  factory LoginState([updates(LoginStateBuilder b)]) = _$LoginState;
}

@immutable
abstract class NotificationState
    implements Built<NotificationState, NotificationStateBuilder> {
  @nullable
  BuiltList<Notification> get notifications;
  bool get loading => notifications == null;
  bool get hasNotifications => !loading && notifications.isNotEmpty;
  static Serializer<NotificationState> get serializer =>
      _$notificationStateSerializer;

  NotificationState._();
  factory NotificationState([updates(NotificationStateBuilder b)]) =
      _$NotificationState;
}

@immutable
abstract class Config implements Built<Config, ConfigBuilder> {
  int get userId;
  int get autoLogoutSeconds;
  String get fullName;
  String get imgSource;
  static Serializer<Config> get serializer => _$configSerializer;

  Config._();
  factory Config([updates(ConfigBuilder b)]) = _$Config;
}

abstract class GradesState implements Built<GradesState, GradesStateBuilder> {
  bool get loading;
  bool get hasGrades => subjects?.isEmpty != true;
  Semester get semester;
  BuiltList<AllSemesterSubject> get subjects;
  BuiltMap<int, SubjectGraphConfig> get graphConfigs;

  /// If unknown: null
  @nullable
  @BuiltValueField(serialize: false)
  int get serverSemester;

  static Serializer<GradesState> get serializer => _$gradesStateSerializer;

  GradesState._();
  factory GradesState([updates(GradesStateBuilder b)]) = _$GradesState;
}

abstract class SubjectGraphConfig
    implements Built<SubjectGraphConfig, SubjectGraphConfigBuilder> {
  int get thick;
  int get color;

  static Serializer<SubjectGraphConfig> get serializer =>
      _$subjectGraphConfigSerializer;

  SubjectGraphConfig._();
  factory SubjectGraphConfig([updates(SubjectGraphConfigBuilder b)]) =
      _$SubjectGraphConfig;
}

abstract class Semester implements Built<Semester, SemesterBuilder> {
  String get name;
  @nullable
  int get n;
  static final first = _$Semester((b) => b
    ..name = "1. Semester"
    ..n = 1).toBuilder();
  static final second = _$Semester((b) => b
    ..name = "2. Semester"
    ..n = 2).toBuilder();
  static final all = _$Semester((b) => b..name = "Beide Semester").toBuilder();
  static final values = [first, second, all];
  static Serializer<Semester> get serializer => _$semesterSerializer;

  Semester._();
  factory Semester._i([updates(SemesterBuilder b)]) = _$Semester;
}

abstract class SettingsState
    implements Built<SettingsState, SettingsStateBuilder> {
  bool get noPasswordSaving;
  bool get noDataSaving;

  /// true = sort grades inside subjects by type;
  ///
  /// false = sort grades inside subjects by date
  bool get typeSorted;
  bool get noAverageForAllSemester;
  bool get doubleTapForDone;
  bool get askWhenDelete;
  bool get showCancelled;
  bool get deleteDataOnLogout;
  bool get calendarShowDates;
  bool get offlineEnabled;
  bool get saveToSecureStorage;
  SettingsState._();
  static Serializer<SettingsState> get serializer => _$settingsStateSerializer;

  factory SettingsState([updates(SettingsStateBuilder b)]) = _$SettingsState;
}

abstract class SettingsStateBuilder
    implements Builder<SettingsState, SettingsStateBuilder> {
  SettingsStateBuilder._();
  factory SettingsStateBuilder() = _$SettingsStateBuilder;
  bool typeSorted;
  bool noAverageForAllSemester;
  bool doubleTapForDone;
  bool askWhenDelete = true;
  bool showCancelled;
  bool deleteDataOnLogout =
      false; // example for a new setting and backward compatibility
  bool noPasswordSaving;
  bool noDataSaving;
  bool calendarShowDates = false;
  bool offlineEnabled = true;
  bool saveToSecureStorage = true;
}

abstract class AbsenceState
    implements Built<AbsenceState, AbsenceStateBuilder> {
  AbsenceState._();
  factory AbsenceState([updates(AbsenceStateBuilder b)]) = _$AbsenceState;
  static Serializer<AbsenceState> get serializer => _$absenceStateSerializer;

  AbsenceStatistic get statistic;
  BuiltList<AbsenceGroup> get absences;
}

abstract class CalendarState
    implements Built<CalendarState, CalendarStateBuilder> {
  BuiltMap<DateTime, CalendarDay> get days;
  DateTime get currentMonday;

  CalendarState._();
  factory CalendarState([updates(CalendarStateBuilder b)]) = _$CalendarState;
  static Serializer<CalendarState> get serializer => _$calendarStateSerializer;
}

abstract class NetworkProtocolState
    implements Built<NetworkProtocolState, NetworkProtocolStateBuilder> {
  BuiltList<NetworkProtocolItem> get items;

  NetworkProtocolState._();
  factory NetworkProtocolState([updates(NetworkProtocolStateBuilder b)]) =
      _$NetworkProtocolState;
}

abstract class NetworkProtocolItem
    implements Built<NetworkProtocolItem, NetworkProtocolItemBuilder> {
  String get address;
  String get parameters;
  String get response;

  NetworkProtocolItem._();
  factory NetworkProtocolItem([updates(NetworkProtocolItemBuilder b)]) =
      _$NetworkProtocolItem;
}
