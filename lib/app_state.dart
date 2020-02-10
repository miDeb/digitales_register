library app_state;

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:meta/meta.dart';

import 'data.dart';

part 'app_state.g.dart';

abstract class AppState implements Built<AppState, AppStateBuilder> {
  DashboardState get dashboardState;
  @BuiltValueField(serialize: false)
  LoginState get loginState;
  NotificationState get notificationState;
  GradesState get gradesState;
  @nullable
  AbsencesState get absencesState;
  @nullable
  @BuiltValueField(serialize: false)
  Config get config;
  @BuiltValueField(serialize: false)
  bool get noInternet;
  @BuiltValueField(serialize: false)
  bool get currentRouteIsLogin;
  @nullable
  SettingsState get settingsState;
  CalendarState get calendarState;
  CertificateState get certificateState;
  @nullable
  @BuiltValueField(serialize: false)
  NetworkProtocolState get networkProtocolState;
  static Serializer<AppState> get serializer => _$appStateSerializer;
  AppState._();
  factory AppState([updates(AppStateBuilder b)]) = _$AppState;
  static void _initializeBuilder(AppStateBuilder builder) {
    builder
      ..dashboardState = DashboardStateBuilder()
      ..loginState = LoginStateBuilder()
      ..notificationState = NotificationStateBuilder()
      ..gradesState = GradesStateBuilder()
      ..calendarState = CalendarStateBuilder()
      ..settingsState = SettingsStateBuilder()
      ..certificateState = CertificateStateBuilder()
      ..currentRouteIsLogin = false
      ..noInternet = false;
  }
}

abstract class DashboardState implements Built<DashboardState, DashboardStateBuilder> {
  bool get loading;
  bool get future;
  @nullable
  BuiltList<HomeworkType> get blacklist;
  @nullable
  BuiltList<Day> get allDays;
  static Serializer<DashboardState> get serializer => _$dashboardStateSerializer;

  DashboardState._();
  factory DashboardState([updates(DashboardStateBuilder b)]) = _$DashboardState;
  static void _initializeBuilder(DashboardStateBuilder builder) {
    builder
      ..future = true
      ..loading = false
      ..blacklist = ListBuilder([]);
  }
}

abstract class LoginState implements Built<LoginState, LoginStateBuilder> {
  bool get loggedIn;
  bool get loading;
  @nullable
  String get errorMsg;
  @nullable
  String get userName;
  bool get changePassword;
  bool get mustChangePassword;
  static Serializer<LoginState> get serializer => _$loginStateSerializer;
  LoginState._();
  factory LoginState([updates(LoginStateBuilder b)]) = _$LoginState;
  static void _initializeBuilder(LoginStateBuilder builder) {
    builder
      ..loggedIn = false
      ..loading = false
      ..changePassword = false
      ..mustChangePassword = true;
  }
}

@immutable
abstract class NotificationState implements Built<NotificationState, NotificationStateBuilder> {
  @nullable
  BuiltList<Notification> get notifications;
  bool get loading => notifications == null;
  bool get hasNotifications => !loading && notifications.isNotEmpty;
  static Serializer<NotificationState> get serializer => _$notificationStateSerializer;

  NotificationState._();
  factory NotificationState([updates(NotificationStateBuilder b)]) = _$NotificationState;
}

@immutable
abstract class Config implements Built<Config, ConfigBuilder> {
  int get userId;
  int get autoLogoutSeconds;
  String get fullName;
  String get imgSource;
  @nullable
  int get currentSemesterMaybe;
  static Serializer<Config> get serializer => _$configSerializer;

  Config._();
  factory Config([updates(ConfigBuilder b)]) = _$Config;
}

abstract class GradesState implements Built<GradesState, GradesStateBuilder> {
  @BuiltValueField(serialize: false)
  bool get loading;
  bool get hasGrades => subjects?.isEmpty != true;
  Semester get semester;
  BuiltList<Subject> get subjects;

  /// If unknown: null
  @nullable
  @BuiltValueField(serialize: false)
  Semester get serverSemester;

  static Serializer<GradesState> get serializer => _$gradesStateSerializer;

  GradesState._();
  factory GradesState([updates(GradesStateBuilder b)]) = _$GradesState;
  static void _initializeBuilder(GradesStateBuilder builder) {
    builder
      ..semester = Semester.all.toBuilder()
      ..subjects = ListBuilder([])
      ..loading = false;
  }
}

abstract class SubjectGraphConfig implements Built<SubjectGraphConfig, SubjectGraphConfigBuilder> {
  int get thick;
  int get color;

  static Serializer<SubjectGraphConfig> get serializer => _$subjectGraphConfigSerializer;

  SubjectGraphConfig._();
  factory SubjectGraphConfig([updates(SubjectGraphConfigBuilder b)]) = _$SubjectGraphConfig;
}

abstract class Semester implements Built<Semester, SemesterBuilder> {
  String get name;
  @nullable
  int get n;
  static final first = _$Semester((b) => b
    ..name = "1. Semester"
    ..n = 1);
  static final second = _$Semester((b) => b
    ..name = "2. Semester"
    ..n = 2);
  static final all = _$Semester((b) => b..name = "Beide Semester");
  static final values = [first, second, all];
  static Serializer<Semester> get serializer => _$semesterSerializer;
  factory Semester([void Function(SemesterBuilder) updates]) = _$Semester;
  Semester._();
}

abstract class SettingsState implements Built<SettingsState, SettingsStateBuilder> {
  bool get noPasswordSaving;
  bool get noDataSaving;

  /// true = sort grades inside subjects by type;
  ///
  /// false = sort grades inside subjects by date
  bool get typeSorted;
  bool get askWhenDelete;
  bool get showCancelled;
  bool get deleteDataOnLogout;
  bool get offlineEnabled;
  BuiltMap<String, String> get subjectNicks;

  // This is not a setting, but relevant for the UI behavior
  // of the settings page and is therefore not serialized
  @nullable
  @BuiltValueField(serialize: false)
  bool get scrollToSubjectNicks;
  bool get showCalendarNicksBar;
  bool get showGradesDiagram;
  bool get showAllSubjectsAverage;
  bool get dashboardMarkNewOrChangedEntries;
  BuiltMap<int, SubjectGraphConfig> get graphConfigs;

  SettingsState._();
  static Serializer<SettingsState> get serializer => _$settingsStateSerializer;
  factory SettingsState([updates(SettingsStateBuilder b)]) = _$SettingsState;
  static void _initializeBuilder(SettingsStateBuilder builder) {
    builder
      ..noPasswordSaving = false
      ..noDataSaving = false
      ..typeSorted = false
      ..askWhenDelete = false
      ..showCancelled = false
      ..deleteDataOnLogout = false
      ..offlineEnabled = true
      ..subjectNicks = MapBuilder<String, String>({
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
      ..graphConfigs = MapBuilder<int, SubjectGraphConfig>();
  }
}

abstract class AbsencesState implements Built<AbsencesState, AbsencesStateBuilder> {
  AbsencesState._();
  factory AbsencesState([updates(AbsencesStateBuilder b)]) = _$AbsencesState;
  static Serializer<AbsencesState> get serializer => _$absencesStateSerializer;

  AbsenceStatistic get statistic;
  BuiltList<AbsenceGroup> get absences;
}

abstract class CalendarState implements Built<CalendarState, CalendarStateBuilder> {
  BuiltMap<DateTime, CalendarDay> get days;
  @nullable
  @BuiltValueField(serialize: false)
  DateTime get currentMonday;

  List<CalendarDay> get currentDays {
    return daysForWeek(currentMonday);
  }

  List<CalendarDay> daysForWeek(DateTime monday) {
    return days.values.where(
      (d) {
        final date = DateTime.utc(d.date.year, d.date.month, d.date.day);
        return !date.isBefore(monday) && date.isBefore(monday.add(Duration(days: 7)));
      },
    ).toList();
  }

  CalendarState._();
  factory CalendarState([updates(CalendarStateBuilder b)]) = _$CalendarState;
  static Serializer<CalendarState> get serializer => _$calendarStateSerializer;
  static void _initializeBuilder(CalendarStateBuilder builder) {
    builder..days = MapBuilder<DateTime, CalendarDay>();
  }
}

abstract class CertificateState implements Built<CertificateState, CertificateStateBuilder> {
  String get html;

  CertificateState._();
  factory CertificateState([void Function(CertificateStateBuilder) updates]) = _$CertificateState;
  static Serializer<CertificateState> get serializer => _$certificateStateSerializer;
  static void _initializeBuilder(CertificateStateBuilder builder) {
    builder..html = "Nichts vorhanden - das ist ein experimentelles Feature";
  }
}

abstract class NetworkProtocolState
    implements Built<NetworkProtocolState, NetworkProtocolStateBuilder> {
  BuiltList<NetworkProtocolItem> get items;

  NetworkProtocolState._();
  factory NetworkProtocolState([updates(NetworkProtocolStateBuilder b)]) = _$NetworkProtocolState;
}

abstract class NetworkProtocolItem
    implements Built<NetworkProtocolItem, NetworkProtocolItemBuilder> {
  String get address;
  String get parameters;
  String get response;

  NetworkProtocolItem._();
  factory NetworkProtocolItem([updates(NetworkProtocolItemBuilder b)]) = _$NetworkProtocolItem;
}
