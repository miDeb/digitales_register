// GENERATED CODE - DO NOT MODIFY BY HAND

part of app_state;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<AppState> _$appStateSerializer = new _$AppStateSerializer();
Serializer<DashboardState> _$dashboardStateSerializer = new _$DashboardStateSerializer();
Serializer<LoginState> _$loginStateSerializer = new _$LoginStateSerializer();
Serializer<NotificationState> _$notificationStateSerializer = new _$NotificationStateSerializer();
Serializer<Config> _$configSerializer = new _$ConfigSerializer();
Serializer<GradesState> _$gradesStateSerializer = new _$GradesStateSerializer();
Serializer<SubjectGraphConfig> _$subjectGraphConfigSerializer =
    new _$SubjectGraphConfigSerializer();
Serializer<Semester> _$semesterSerializer = new _$SemesterSerializer();
Serializer<SettingsState> _$settingsStateSerializer = new _$SettingsStateSerializer();
Serializer<AbsencesState> _$absencesStateSerializer = new _$AbsencesStateSerializer();
Serializer<CalendarState> _$calendarStateSerializer = new _$CalendarStateSerializer();

class _$AppStateSerializer implements StructuredSerializer<AppState> {
  @override
  final Iterable<Type> types = const [AppState, _$AppState];
  @override
  final String wireName = 'AppState';

  @override
  Iterable<Object> serialize(Serializers serializers, AppState object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'dashboardState',
      serializers.serialize(object.dashboardState, specifiedType: const FullType(DashboardState)),
      'notificationState',
      serializers.serialize(object.notificationState,
          specifiedType: const FullType(NotificationState)),
      'gradesState',
      serializers.serialize(object.gradesState, specifiedType: const FullType(GradesState)),
      'calendarState',
      serializers.serialize(object.calendarState, specifiedType: const FullType(CalendarState)),
    ];
    if (object.absencesState != null) {
      result
        ..add('absencesState')
        ..add(serializers.serialize(object.absencesState,
            specifiedType: const FullType(AbsencesState)));
    }
    if (object.settingsState != null) {
      result
        ..add('settingsState')
        ..add(serializers.serialize(object.settingsState,
            specifiedType: const FullType(SettingsState)));
    }
    return result;
  }

  @override
  AppState deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new AppStateBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'dashboardState':
          result.dashboardState.replace(serializers.deserialize(value,
              specifiedType: const FullType(DashboardState)) as DashboardState);
          break;
        case 'notificationState':
          result.notificationState.replace(serializers.deserialize(value,
              specifiedType: const FullType(NotificationState)) as NotificationState);
          break;
        case 'gradesState':
          result.gradesState.replace(serializers.deserialize(value,
              specifiedType: const FullType(GradesState)) as GradesState);
          break;
        case 'absencesState':
          result.absencesState.replace(serializers.deserialize(value,
              specifiedType: const FullType(AbsencesState)) as AbsencesState);
          break;
        case 'settingsState':
          result.settingsState.replace(serializers.deserialize(value,
              specifiedType: const FullType(SettingsState)) as SettingsState);
          break;
        case 'calendarState':
          result.calendarState.replace(serializers.deserialize(value,
              specifiedType: const FullType(CalendarState)) as CalendarState);
          break;
      }
    }

    return result.build();
  }
}

class _$DashboardStateSerializer implements StructuredSerializer<DashboardState> {
  @override
  final Iterable<Type> types = const [DashboardState, _$DashboardState];
  @override
  final String wireName = 'DashboardState';

  @override
  Iterable<Object> serialize(Serializers serializers, DashboardState object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'loading',
      serializers.serialize(object.loading, specifiedType: const FullType(bool)),
      'future',
      serializers.serialize(object.future, specifiedType: const FullType(bool)),
    ];
    if (object.blacklist != null) {
      result
        ..add('blacklist')
        ..add(serializers.serialize(object.blacklist,
            specifiedType: const FullType(BuiltList, const [const FullType(HomeworkType)])));
    }
    if (object.allDays != null) {
      result
        ..add('allDays')
        ..add(serializers.serialize(object.allDays,
            specifiedType: const FullType(BuiltList, const [const FullType(Day)])));
    }
    return result;
  }

  @override
  DashboardState deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new DashboardStateBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'loading':
          result.loading =
              serializers.deserialize(value, specifiedType: const FullType(bool)) as bool;
          break;
        case 'future':
          result.future =
              serializers.deserialize(value, specifiedType: const FullType(bool)) as bool;
          break;
        case 'blacklist':
          result.blacklist.replace(serializers.deserialize(value,
                  specifiedType: const FullType(BuiltList, const [const FullType(HomeworkType)]))
              as BuiltList<dynamic>);
          break;
        case 'allDays':
          result.allDays.replace(serializers.deserialize(value,
                  specifiedType: const FullType(BuiltList, const [const FullType(Day)]))
              as BuiltList<dynamic>);
          break;
      }
    }

    return result.build();
  }
}

class _$LoginStateSerializer implements StructuredSerializer<LoginState> {
  @override
  final Iterable<Type> types = const [LoginState, _$LoginState];
  @override
  final String wireName = 'LoginState';

  @override
  Iterable<Object> serialize(Serializers serializers, LoginState object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'loggedIn',
      serializers.serialize(object.loggedIn, specifiedType: const FullType(bool)),
      'loading',
      serializers.serialize(object.loading, specifiedType: const FullType(bool)),
    ];
    if (object.errorMsg != null) {
      result
        ..add('errorMsg')
        ..add(serializers.serialize(object.errorMsg, specifiedType: const FullType(String)));
    }
    if (object.userName != null) {
      result
        ..add('userName')
        ..add(serializers.serialize(object.userName, specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  LoginState deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new LoginStateBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'loggedIn':
          result.loggedIn =
              serializers.deserialize(value, specifiedType: const FullType(bool)) as bool;
          break;
        case 'loading':
          result.loading =
              serializers.deserialize(value, specifiedType: const FullType(bool)) as bool;
          break;
        case 'errorMsg':
          result.errorMsg =
              serializers.deserialize(value, specifiedType: const FullType(String)) as String;
          break;
        case 'userName':
          result.userName =
              serializers.deserialize(value, specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$NotificationStateSerializer implements StructuredSerializer<NotificationState> {
  @override
  final Iterable<Type> types = const [NotificationState, _$NotificationState];
  @override
  final String wireName = 'NotificationState';

  @override
  Iterable<Object> serialize(Serializers serializers, NotificationState object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[];
    if (object.notifications != null) {
      result
        ..add('notifications')
        ..add(serializers.serialize(object.notifications,
            specifiedType: const FullType(BuiltList, const [const FullType(Notification)])));
    }
    return result;
  }

  @override
  NotificationState deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new NotificationStateBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'notifications':
          result.notifications.replace(serializers.deserialize(value,
                  specifiedType: const FullType(BuiltList, const [const FullType(Notification)]))
              as BuiltList<dynamic>);
          break;
      }
    }

    return result.build();
  }
}

class _$ConfigSerializer implements StructuredSerializer<Config> {
  @override
  final Iterable<Type> types = const [Config, _$Config];
  @override
  final String wireName = 'Config';

  @override
  Iterable<Object> serialize(Serializers serializers, Config object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'userId',
      serializers.serialize(object.userId, specifiedType: const FullType(int)),
      'autoLogoutSeconds',
      serializers.serialize(object.autoLogoutSeconds, specifiedType: const FullType(int)),
      'fullName',
      serializers.serialize(object.fullName, specifiedType: const FullType(String)),
      'imgSource',
      serializers.serialize(object.imgSource, specifiedType: const FullType(String)),
    ];
    if (object.currentSemesterMaybe != null) {
      result
        ..add('currentSemesterMaybe')
        ..add(
            serializers.serialize(object.currentSemesterMaybe, specifiedType: const FullType(int)));
    }
    return result;
  }

  @override
  Config deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ConfigBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'userId':
          result.userId = serializers.deserialize(value, specifiedType: const FullType(int)) as int;
          break;
        case 'autoLogoutSeconds':
          result.autoLogoutSeconds =
              serializers.deserialize(value, specifiedType: const FullType(int)) as int;
          break;
        case 'fullName':
          result.fullName =
              serializers.deserialize(value, specifiedType: const FullType(String)) as String;
          break;
        case 'imgSource':
          result.imgSource =
              serializers.deserialize(value, specifiedType: const FullType(String)) as String;
          break;
        case 'currentSemesterMaybe':
          result.currentSemesterMaybe =
              serializers.deserialize(value, specifiedType: const FullType(int)) as int;
          break;
      }
    }

    return result.build();
  }
}

class _$GradesStateSerializer implements StructuredSerializer<GradesState> {
  @override
  final Iterable<Type> types = const [GradesState, _$GradesState];
  @override
  final String wireName = 'GradesState';

  @override
  Iterable<Object> serialize(Serializers serializers, GradesState object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'semester',
      serializers.serialize(object.semester, specifiedType: const FullType(Semester)),
      'subjects',
      serializers.serialize(object.subjects,
          specifiedType: const FullType(BuiltList, const [const FullType(Subject)])),
    ];

    return result;
  }

  @override
  GradesState deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new GradesStateBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'semester':
          result.semester.replace(
              serializers.deserialize(value, specifiedType: const FullType(Semester)) as Semester);
          break;
        case 'subjects':
          result.subjects.replace(serializers.deserialize(value,
                  specifiedType: const FullType(BuiltList, const [const FullType(Subject)]))
              as BuiltList<dynamic>);
          break;
      }
    }

    return result.build();
  }
}

class _$SubjectGraphConfigSerializer implements StructuredSerializer<SubjectGraphConfig> {
  @override
  final Iterable<Type> types = const [SubjectGraphConfig, _$SubjectGraphConfig];
  @override
  final String wireName = 'SubjectGraphConfig';

  @override
  Iterable<Object> serialize(Serializers serializers, SubjectGraphConfig object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'thick',
      serializers.serialize(object.thick, specifiedType: const FullType(int)),
      'color',
      serializers.serialize(object.color, specifiedType: const FullType(int)),
    ];

    return result;
  }

  @override
  SubjectGraphConfig deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new SubjectGraphConfigBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'thick':
          result.thick = serializers.deserialize(value, specifiedType: const FullType(int)) as int;
          break;
        case 'color':
          result.color = serializers.deserialize(value, specifiedType: const FullType(int)) as int;
          break;
      }
    }

    return result.build();
  }
}

class _$SemesterSerializer implements StructuredSerializer<Semester> {
  @override
  final Iterable<Type> types = const [Semester, _$Semester];
  @override
  final String wireName = 'Semester';

  @override
  Iterable<Object> serialize(Serializers serializers, Semester object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
    ];
    if (object.n != null) {
      result..add('n')..add(serializers.serialize(object.n, specifiedType: const FullType(int)));
    }
    return result;
  }

  @override
  Semester deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new SemesterBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'name':
          result.name =
              serializers.deserialize(value, specifiedType: const FullType(String)) as String;
          break;
        case 'n':
          result.n = serializers.deserialize(value, specifiedType: const FullType(int)) as int;
          break;
      }
    }

    return result.build();
  }
}

class _$SettingsStateSerializer implements StructuredSerializer<SettingsState> {
  @override
  final Iterable<Type> types = const [SettingsState, _$SettingsState];
  @override
  final String wireName = 'SettingsState';

  @override
  Iterable<Object> serialize(Serializers serializers, SettingsState object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'noPasswordSaving',
      serializers.serialize(object.noPasswordSaving, specifiedType: const FullType(bool)),
      'noDataSaving',
      serializers.serialize(object.noDataSaving, specifiedType: const FullType(bool)),
      'typeSorted',
      serializers.serialize(object.typeSorted, specifiedType: const FullType(bool)),
      'askWhenDelete',
      serializers.serialize(object.askWhenDelete, specifiedType: const FullType(bool)),
      'showCancelled',
      serializers.serialize(object.showCancelled, specifiedType: const FullType(bool)),
      'deleteDataOnLogout',
      serializers.serialize(object.deleteDataOnLogout, specifiedType: const FullType(bool)),
      'offlineEnabled',
      serializers.serialize(object.offlineEnabled, specifiedType: const FullType(bool)),
      'subjectNicks',
      serializers.serialize(object.subjectNicks,
          specifiedType:
              const FullType(BuiltMap, const [const FullType(String), const FullType(String)])),
      'showCalendarNicksBar',
      serializers.serialize(object.showCalendarNicksBar, specifiedType: const FullType(bool)),
      'showGradesDiagram',
      serializers.serialize(object.showGradesDiagram, specifiedType: const FullType(bool)),
      'showAllSubjectsAverage',
      serializers.serialize(object.showAllSubjectsAverage, specifiedType: const FullType(bool)),
      'dashboardMarkNewOrChangedEntries',
      serializers.serialize(object.dashboardMarkNewOrChangedEntries,
          specifiedType: const FullType(bool)),
      'graphConfigs',
      serializers.serialize(object.graphConfigs,
          specifiedType: const FullType(
              BuiltMap, const [const FullType(int), const FullType(SubjectGraphConfig)])),
    ];

    return result;
  }

  @override
  SettingsState deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new SettingsStateBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'noPasswordSaving':
          result.noPasswordSaving =
              serializers.deserialize(value, specifiedType: const FullType(bool)) as bool;
          break;
        case 'noDataSaving':
          result.noDataSaving =
              serializers.deserialize(value, specifiedType: const FullType(bool)) as bool;
          break;
        case 'typeSorted':
          result.typeSorted =
              serializers.deserialize(value, specifiedType: const FullType(bool)) as bool;
          break;
        case 'askWhenDelete':
          result.askWhenDelete =
              serializers.deserialize(value, specifiedType: const FullType(bool)) as bool;
          break;
        case 'showCancelled':
          result.showCancelled =
              serializers.deserialize(value, specifiedType: const FullType(bool)) as bool;
          break;
        case 'deleteDataOnLogout':
          result.deleteDataOnLogout =
              serializers.deserialize(value, specifiedType: const FullType(bool)) as bool;
          break;
        case 'offlineEnabled':
          result.offlineEnabled =
              serializers.deserialize(value, specifiedType: const FullType(bool)) as bool;
          break;
        case 'subjectNicks':
          result.subjectNicks.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltMap, const [const FullType(String), const FullType(String)]))
              as BuiltMap<dynamic, dynamic>);
          break;
        case 'showCalendarNicksBar':
          result.showCalendarNicksBar =
              serializers.deserialize(value, specifiedType: const FullType(bool)) as bool;
          break;
        case 'showGradesDiagram':
          result.showGradesDiagram =
              serializers.deserialize(value, specifiedType: const FullType(bool)) as bool;
          break;
        case 'showAllSubjectsAverage':
          result.showAllSubjectsAverage =
              serializers.deserialize(value, specifiedType: const FullType(bool)) as bool;
          break;
        case 'dashboardMarkNewOrChangedEntries':
          result.dashboardMarkNewOrChangedEntries =
              serializers.deserialize(value, specifiedType: const FullType(bool)) as bool;
          break;
        case 'graphConfigs':
          result.graphConfigs.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltMap, const [const FullType(int), const FullType(SubjectGraphConfig)]))
              as BuiltMap<dynamic, dynamic>);
          break;
      }
    }

    return result.build();
  }
}

class _$AbsencesStateSerializer implements StructuredSerializer<AbsencesState> {
  @override
  final Iterable<Type> types = const [AbsencesState, _$AbsencesState];
  @override
  final String wireName = 'AbsencesState';

  @override
  Iterable<Object> serialize(Serializers serializers, AbsencesState object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'statistic',
      serializers.serialize(object.statistic, specifiedType: const FullType(AbsenceStatistic)),
      'absences',
      serializers.serialize(object.absences,
          specifiedType: const FullType(BuiltList, const [const FullType(AbsenceGroup)])),
    ];

    return result;
  }

  @override
  AbsencesState deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new AbsencesStateBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'statistic':
          result.statistic.replace(serializers.deserialize(value,
              specifiedType: const FullType(AbsenceStatistic)) as AbsenceStatistic);
          break;
        case 'absences':
          result.absences.replace(serializers.deserialize(value,
                  specifiedType: const FullType(BuiltList, const [const FullType(AbsenceGroup)]))
              as BuiltList<dynamic>);
          break;
      }
    }

    return result.build();
  }
}

class _$CalendarStateSerializer implements StructuredSerializer<CalendarState> {
  @override
  final Iterable<Type> types = const [CalendarState, _$CalendarState];
  @override
  final String wireName = 'CalendarState';

  @override
  Iterable<Object> serialize(Serializers serializers, CalendarState object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'days',
      serializers.serialize(object.days,
          specifiedType: const FullType(
              BuiltMap, const [const FullType(DateTime), const FullType(CalendarDay)])),
    ];

    return result;
  }

  @override
  CalendarState deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new CalendarStateBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'days':
          result.days.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltMap, const [const FullType(DateTime), const FullType(CalendarDay)]))
              as BuiltMap<dynamic, dynamic>);
          break;
      }
    }

    return result.build();
  }
}

class _$AppState extends AppState {
  @override
  final DashboardState dashboardState;
  @override
  final LoginState loginState;
  @override
  final NotificationState notificationState;
  @override
  final GradesState gradesState;
  @override
  final AbsencesState absencesState;
  @override
  final Config config;
  @override
  final bool noInternet;
  @override
  final bool currentRouteIsLogin;
  @override
  final SettingsState settingsState;
  @override
  final CalendarState calendarState;
  @override
  final NetworkProtocolState networkProtocolState;

  factory _$AppState([void Function(AppStateBuilder) updates]) =>
      (new AppStateBuilder()..update(updates)).build();

  _$AppState._(
      {this.dashboardState,
      this.loginState,
      this.notificationState,
      this.gradesState,
      this.absencesState,
      this.config,
      this.noInternet,
      this.currentRouteIsLogin,
      this.settingsState,
      this.calendarState,
      this.networkProtocolState})
      : super._() {
    if (dashboardState == null) {
      throw new BuiltValueNullFieldError('AppState', 'dashboardState');
    }
    if (loginState == null) {
      throw new BuiltValueNullFieldError('AppState', 'loginState');
    }
    if (notificationState == null) {
      throw new BuiltValueNullFieldError('AppState', 'notificationState');
    }
    if (gradesState == null) {
      throw new BuiltValueNullFieldError('AppState', 'gradesState');
    }
    if (noInternet == null) {
      throw new BuiltValueNullFieldError('AppState', 'noInternet');
    }
    if (currentRouteIsLogin == null) {
      throw new BuiltValueNullFieldError('AppState', 'currentRouteIsLogin');
    }
    if (calendarState == null) {
      throw new BuiltValueNullFieldError('AppState', 'calendarState');
    }
  }

  @override
  AppState rebuild(void Function(AppStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AppStateBuilder toBuilder() => new AppStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AppState &&
        dashboardState == other.dashboardState &&
        loginState == other.loginState &&
        notificationState == other.notificationState &&
        gradesState == other.gradesState &&
        absencesState == other.absencesState &&
        config == other.config &&
        noInternet == other.noInternet &&
        currentRouteIsLogin == other.currentRouteIsLogin &&
        settingsState == other.settingsState &&
        calendarState == other.calendarState &&
        networkProtocolState == other.networkProtocolState;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc(
                        $jc(
                            $jc(
                                $jc(
                                    $jc($jc($jc(0, dashboardState.hashCode), loginState.hashCode),
                                        notificationState.hashCode),
                                    gradesState.hashCode),
                                absencesState.hashCode),
                            config.hashCode),
                        noInternet.hashCode),
                    currentRouteIsLogin.hashCode),
                settingsState.hashCode),
            calendarState.hashCode),
        networkProtocolState.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('AppState')
          ..add('dashboardState', dashboardState)
          ..add('loginState', loginState)
          ..add('notificationState', notificationState)
          ..add('gradesState', gradesState)
          ..add('absencesState', absencesState)
          ..add('config', config)
          ..add('noInternet', noInternet)
          ..add('currentRouteIsLogin', currentRouteIsLogin)
          ..add('settingsState', settingsState)
          ..add('calendarState', calendarState)
          ..add('networkProtocolState', networkProtocolState))
        .toString();
  }
}

class AppStateBuilder implements Builder<AppState, AppStateBuilder> {
  _$AppState _$v;

  DashboardStateBuilder _dashboardState;
  DashboardStateBuilder get dashboardState =>
      _$this._dashboardState ??= new DashboardStateBuilder();
  set dashboardState(DashboardStateBuilder dashboardState) =>
      _$this._dashboardState = dashboardState;

  LoginStateBuilder _loginState;
  LoginStateBuilder get loginState => _$this._loginState ??= new LoginStateBuilder();
  set loginState(LoginStateBuilder loginState) => _$this._loginState = loginState;

  NotificationStateBuilder _notificationState;
  NotificationStateBuilder get notificationState =>
      _$this._notificationState ??= new NotificationStateBuilder();
  set notificationState(NotificationStateBuilder notificationState) =>
      _$this._notificationState = notificationState;

  GradesStateBuilder _gradesState;
  GradesStateBuilder get gradesState => _$this._gradesState ??= new GradesStateBuilder();
  set gradesState(GradesStateBuilder gradesState) => _$this._gradesState = gradesState;

  AbsencesStateBuilder _absencesState;
  AbsencesStateBuilder get absencesState => _$this._absencesState ??= new AbsencesStateBuilder();
  set absencesState(AbsencesStateBuilder absencesState) => _$this._absencesState = absencesState;

  ConfigBuilder _config;
  ConfigBuilder get config => _$this._config ??= new ConfigBuilder();
  set config(ConfigBuilder config) => _$this._config = config;

  bool _noInternet;
  bool get noInternet => _$this._noInternet;
  set noInternet(bool noInternet) => _$this._noInternet = noInternet;

  bool _currentRouteIsLogin;
  bool get currentRouteIsLogin => _$this._currentRouteIsLogin;
  set currentRouteIsLogin(bool currentRouteIsLogin) =>
      _$this._currentRouteIsLogin = currentRouteIsLogin;

  SettingsStateBuilder _settingsState;
  SettingsStateBuilder get settingsState => _$this._settingsState ??= new SettingsStateBuilder();
  set settingsState(SettingsStateBuilder settingsState) => _$this._settingsState = settingsState;

  CalendarStateBuilder _calendarState;
  CalendarStateBuilder get calendarState => _$this._calendarState ??= new CalendarStateBuilder();
  set calendarState(CalendarStateBuilder calendarState) => _$this._calendarState = calendarState;

  NetworkProtocolStateBuilder _networkProtocolState;
  NetworkProtocolStateBuilder get networkProtocolState =>
      _$this._networkProtocolState ??= new NetworkProtocolStateBuilder();
  set networkProtocolState(NetworkProtocolStateBuilder networkProtocolState) =>
      _$this._networkProtocolState = networkProtocolState;

  AppStateBuilder() {
    AppState._initializeBuilder(this);
  }

  AppStateBuilder get _$this {
    if (_$v != null) {
      _dashboardState = _$v.dashboardState?.toBuilder();
      _loginState = _$v.loginState?.toBuilder();
      _notificationState = _$v.notificationState?.toBuilder();
      _gradesState = _$v.gradesState?.toBuilder();
      _absencesState = _$v.absencesState?.toBuilder();
      _config = _$v.config?.toBuilder();
      _noInternet = _$v.noInternet;
      _currentRouteIsLogin = _$v.currentRouteIsLogin;
      _settingsState = _$v.settingsState?.toBuilder();
      _calendarState = _$v.calendarState?.toBuilder();
      _networkProtocolState = _$v.networkProtocolState?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AppState other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$AppState;
  }

  @override
  void update(void Function(AppStateBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$AppState build() {
    _$AppState _$result;
    try {
      _$result = _$v ??
          new _$AppState._(
              dashboardState: dashboardState.build(),
              loginState: loginState.build(),
              notificationState: notificationState.build(),
              gradesState: gradesState.build(),
              absencesState: _absencesState?.build(),
              config: _config?.build(),
              noInternet: noInternet,
              currentRouteIsLogin: currentRouteIsLogin,
              settingsState: _settingsState?.build(),
              calendarState: calendarState.build(),
              networkProtocolState: _networkProtocolState?.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'dashboardState';
        dashboardState.build();
        _$failedField = 'loginState';
        loginState.build();
        _$failedField = 'notificationState';
        notificationState.build();
        _$failedField = 'gradesState';
        gradesState.build();
        _$failedField = 'absencesState';
        _absencesState?.build();
        _$failedField = 'config';
        _config?.build();

        _$failedField = 'settingsState';
        _settingsState?.build();
        _$failedField = 'calendarState';
        calendarState.build();
        _$failedField = 'networkProtocolState';
        _networkProtocolState?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError('AppState', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$DashboardState extends DashboardState {
  @override
  final bool loading;
  @override
  final bool future;
  @override
  final BuiltList<HomeworkType> blacklist;
  @override
  final BuiltList<Day> allDays;

  factory _$DashboardState([void Function(DashboardStateBuilder) updates]) =>
      (new DashboardStateBuilder()..update(updates)).build();

  _$DashboardState._({this.loading, this.future, this.blacklist, this.allDays}) : super._() {
    if (loading == null) {
      throw new BuiltValueNullFieldError('DashboardState', 'loading');
    }
    if (future == null) {
      throw new BuiltValueNullFieldError('DashboardState', 'future');
    }
  }

  @override
  DashboardState rebuild(void Function(DashboardStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DashboardStateBuilder toBuilder() => new DashboardStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DashboardState &&
        loading == other.loading &&
        future == other.future &&
        blacklist == other.blacklist &&
        allDays == other.allDays;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc($jc(0, loading.hashCode), future.hashCode), blacklist.hashCode), allDays.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('DashboardState')
          ..add('loading', loading)
          ..add('future', future)
          ..add('blacklist', blacklist)
          ..add('allDays', allDays))
        .toString();
  }
}

class DashboardStateBuilder implements Builder<DashboardState, DashboardStateBuilder> {
  _$DashboardState _$v;

  bool _loading;
  bool get loading => _$this._loading;
  set loading(bool loading) => _$this._loading = loading;

  bool _future;
  bool get future => _$this._future;
  set future(bool future) => _$this._future = future;

  ListBuilder<HomeworkType> _blacklist;
  ListBuilder<HomeworkType> get blacklist => _$this._blacklist ??= new ListBuilder<HomeworkType>();
  set blacklist(ListBuilder<HomeworkType> blacklist) => _$this._blacklist = blacklist;

  ListBuilder<Day> _allDays;
  ListBuilder<Day> get allDays => _$this._allDays ??= new ListBuilder<Day>();
  set allDays(ListBuilder<Day> allDays) => _$this._allDays = allDays;

  DashboardStateBuilder() {
    DashboardState._initializeBuilder(this);
  }

  DashboardStateBuilder get _$this {
    if (_$v != null) {
      _loading = _$v.loading;
      _future = _$v.future;
      _blacklist = _$v.blacklist?.toBuilder();
      _allDays = _$v.allDays?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DashboardState other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$DashboardState;
  }

  @override
  void update(void Function(DashboardStateBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$DashboardState build() {
    _$DashboardState _$result;
    try {
      _$result = _$v ??
          new _$DashboardState._(
              loading: loading,
              future: future,
              blacklist: _blacklist?.build(),
              allDays: _allDays?.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'blacklist';
        _blacklist?.build();
        _$failedField = 'allDays';
        _allDays?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError('DashboardState', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$LoginState extends LoginState {
  @override
  final bool loggedIn;
  @override
  final bool loading;
  @override
  final String errorMsg;
  @override
  final String userName;

  factory _$LoginState([void Function(LoginStateBuilder) updates]) =>
      (new LoginStateBuilder()..update(updates)).build();

  _$LoginState._({this.loggedIn, this.loading, this.errorMsg, this.userName}) : super._() {
    if (loggedIn == null) {
      throw new BuiltValueNullFieldError('LoginState', 'loggedIn');
    }
    if (loading == null) {
      throw new BuiltValueNullFieldError('LoginState', 'loading');
    }
  }

  @override
  LoginState rebuild(void Function(LoginStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LoginStateBuilder toBuilder() => new LoginStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LoginState &&
        loggedIn == other.loggedIn &&
        loading == other.loading &&
        errorMsg == other.errorMsg &&
        userName == other.userName;
  }

  @override
  int get hashCode {
    return $jf($jc($jc($jc($jc(0, loggedIn.hashCode), loading.hashCode), errorMsg.hashCode),
        userName.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('LoginState')
          ..add('loggedIn', loggedIn)
          ..add('loading', loading)
          ..add('errorMsg', errorMsg)
          ..add('userName', userName))
        .toString();
  }
}

class LoginStateBuilder implements Builder<LoginState, LoginStateBuilder> {
  _$LoginState _$v;

  bool _loggedIn;
  bool get loggedIn => _$this._loggedIn;
  set loggedIn(bool loggedIn) => _$this._loggedIn = loggedIn;

  bool _loading;
  bool get loading => _$this._loading;
  set loading(bool loading) => _$this._loading = loading;

  String _errorMsg;
  String get errorMsg => _$this._errorMsg;
  set errorMsg(String errorMsg) => _$this._errorMsg = errorMsg;

  String _userName;
  String get userName => _$this._userName;
  set userName(String userName) => _$this._userName = userName;

  LoginStateBuilder() {
    LoginState._initializeBuilder(this);
  }

  LoginStateBuilder get _$this {
    if (_$v != null) {
      _loggedIn = _$v.loggedIn;
      _loading = _$v.loading;
      _errorMsg = _$v.errorMsg;
      _userName = _$v.userName;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LoginState other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$LoginState;
  }

  @override
  void update(void Function(LoginStateBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$LoginState build() {
    final _$result = _$v ??
        new _$LoginState._(
            loggedIn: loggedIn, loading: loading, errorMsg: errorMsg, userName: userName);
    replace(_$result);
    return _$result;
  }
}

class _$NotificationState extends NotificationState {
  @override
  final BuiltList<Notification> notifications;

  factory _$NotificationState([void Function(NotificationStateBuilder) updates]) =>
      (new NotificationStateBuilder()..update(updates)).build();

  _$NotificationState._({this.notifications}) : super._();

  @override
  NotificationState rebuild(void Function(NotificationStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  NotificationStateBuilder toBuilder() => new NotificationStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is NotificationState && notifications == other.notifications;
  }

  @override
  int get hashCode {
    return $jf($jc(0, notifications.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('NotificationState')..add('notifications', notifications))
        .toString();
  }
}

class NotificationStateBuilder implements Builder<NotificationState, NotificationStateBuilder> {
  _$NotificationState _$v;

  ListBuilder<Notification> _notifications;
  ListBuilder<Notification> get notifications =>
      _$this._notifications ??= new ListBuilder<Notification>();
  set notifications(ListBuilder<Notification> notifications) =>
      _$this._notifications = notifications;

  NotificationStateBuilder();

  NotificationStateBuilder get _$this {
    if (_$v != null) {
      _notifications = _$v.notifications?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(NotificationState other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$NotificationState;
  }

  @override
  void update(void Function(NotificationStateBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$NotificationState build() {
    _$NotificationState _$result;
    try {
      _$result = _$v ?? new _$NotificationState._(notifications: _notifications?.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'notifications';
        _notifications?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError('NotificationState', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$Config extends Config {
  @override
  final int userId;
  @override
  final int autoLogoutSeconds;
  @override
  final String fullName;
  @override
  final String imgSource;
  @override
  final int currentSemesterMaybe;

  factory _$Config([void Function(ConfigBuilder) updates]) =>
      (new ConfigBuilder()..update(updates)).build();

  _$Config._(
      {this.userId,
      this.autoLogoutSeconds,
      this.fullName,
      this.imgSource,
      this.currentSemesterMaybe})
      : super._() {
    if (userId == null) {
      throw new BuiltValueNullFieldError('Config', 'userId');
    }
    if (autoLogoutSeconds == null) {
      throw new BuiltValueNullFieldError('Config', 'autoLogoutSeconds');
    }
    if (fullName == null) {
      throw new BuiltValueNullFieldError('Config', 'fullName');
    }
    if (imgSource == null) {
      throw new BuiltValueNullFieldError('Config', 'imgSource');
    }
  }

  @override
  Config rebuild(void Function(ConfigBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  ConfigBuilder toBuilder() => new ConfigBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Config &&
        userId == other.userId &&
        autoLogoutSeconds == other.autoLogoutSeconds &&
        fullName == other.fullName &&
        imgSource == other.imgSource &&
        currentSemesterMaybe == other.currentSemesterMaybe;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc($jc($jc(0, userId.hashCode), autoLogoutSeconds.hashCode), fullName.hashCode),
            imgSource.hashCode),
        currentSemesterMaybe.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Config')
          ..add('userId', userId)
          ..add('autoLogoutSeconds', autoLogoutSeconds)
          ..add('fullName', fullName)
          ..add('imgSource', imgSource)
          ..add('currentSemesterMaybe', currentSemesterMaybe))
        .toString();
  }
}

class ConfigBuilder implements Builder<Config, ConfigBuilder> {
  _$Config _$v;

  int _userId;
  int get userId => _$this._userId;
  set userId(int userId) => _$this._userId = userId;

  int _autoLogoutSeconds;
  int get autoLogoutSeconds => _$this._autoLogoutSeconds;
  set autoLogoutSeconds(int autoLogoutSeconds) => _$this._autoLogoutSeconds = autoLogoutSeconds;

  String _fullName;
  String get fullName => _$this._fullName;
  set fullName(String fullName) => _$this._fullName = fullName;

  String _imgSource;
  String get imgSource => _$this._imgSource;
  set imgSource(String imgSource) => _$this._imgSource = imgSource;

  int _currentSemesterMaybe;
  int get currentSemesterMaybe => _$this._currentSemesterMaybe;
  set currentSemesterMaybe(int currentSemesterMaybe) =>
      _$this._currentSemesterMaybe = currentSemesterMaybe;

  ConfigBuilder();

  ConfigBuilder get _$this {
    if (_$v != null) {
      _userId = _$v.userId;
      _autoLogoutSeconds = _$v.autoLogoutSeconds;
      _fullName = _$v.fullName;
      _imgSource = _$v.imgSource;
      _currentSemesterMaybe = _$v.currentSemesterMaybe;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Config other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Config;
  }

  @override
  void update(void Function(ConfigBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Config build() {
    final _$result = _$v ??
        new _$Config._(
            userId: userId,
            autoLogoutSeconds: autoLogoutSeconds,
            fullName: fullName,
            imgSource: imgSource,
            currentSemesterMaybe: currentSemesterMaybe);
    replace(_$result);
    return _$result;
  }
}

class _$GradesState extends GradesState {
  @override
  final bool loading;
  @override
  final Semester semester;
  @override
  final BuiltList<Subject> subjects;
  @override
  final Semester serverSemester;

  factory _$GradesState([void Function(GradesStateBuilder) updates]) =>
      (new GradesStateBuilder()..update(updates)).build();

  _$GradesState._({this.loading, this.semester, this.subjects, this.serverSemester}) : super._() {
    if (loading == null) {
      throw new BuiltValueNullFieldError('GradesState', 'loading');
    }
    if (semester == null) {
      throw new BuiltValueNullFieldError('GradesState', 'semester');
    }
    if (subjects == null) {
      throw new BuiltValueNullFieldError('GradesState', 'subjects');
    }
  }

  @override
  GradesState rebuild(void Function(GradesStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GradesStateBuilder toBuilder() => new GradesStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GradesState &&
        loading == other.loading &&
        semester == other.semester &&
        subjects == other.subjects &&
        serverSemester == other.serverSemester;
  }

  @override
  int get hashCode {
    return $jf($jc($jc($jc($jc(0, loading.hashCode), semester.hashCode), subjects.hashCode),
        serverSemester.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('GradesState')
          ..add('loading', loading)
          ..add('semester', semester)
          ..add('subjects', subjects)
          ..add('serverSemester', serverSemester))
        .toString();
  }
}

class GradesStateBuilder implements Builder<GradesState, GradesStateBuilder> {
  _$GradesState _$v;

  bool _loading;
  bool get loading => _$this._loading;
  set loading(bool loading) => _$this._loading = loading;

  SemesterBuilder _semester;
  SemesterBuilder get semester => _$this._semester ??= new SemesterBuilder();
  set semester(SemesterBuilder semester) => _$this._semester = semester;

  ListBuilder<Subject> _subjects;
  ListBuilder<Subject> get subjects => _$this._subjects ??= new ListBuilder<Subject>();
  set subjects(ListBuilder<Subject> subjects) => _$this._subjects = subjects;

  SemesterBuilder _serverSemester;
  SemesterBuilder get serverSemester => _$this._serverSemester ??= new SemesterBuilder();
  set serverSemester(SemesterBuilder serverSemester) => _$this._serverSemester = serverSemester;

  GradesStateBuilder() {
    GradesState._initializeBuilder(this);
  }

  GradesStateBuilder get _$this {
    if (_$v != null) {
      _loading = _$v.loading;
      _semester = _$v.semester?.toBuilder();
      _subjects = _$v.subjects?.toBuilder();
      _serverSemester = _$v.serverSemester?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GradesState other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$GradesState;
  }

  @override
  void update(void Function(GradesStateBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$GradesState build() {
    _$GradesState _$result;
    try {
      _$result = _$v ??
          new _$GradesState._(
              loading: loading,
              semester: semester.build(),
              subjects: subjects.build(),
              serverSemester: _serverSemester?.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'semester';
        semester.build();
        _$failedField = 'subjects';
        subjects.build();
        _$failedField = 'serverSemester';
        _serverSemester?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError('GradesState', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$SubjectGraphConfig extends SubjectGraphConfig {
  @override
  final int thick;
  @override
  final int color;

  factory _$SubjectGraphConfig([void Function(SubjectGraphConfigBuilder) updates]) =>
      (new SubjectGraphConfigBuilder()..update(updates)).build();

  _$SubjectGraphConfig._({this.thick, this.color}) : super._() {
    if (thick == null) {
      throw new BuiltValueNullFieldError('SubjectGraphConfig', 'thick');
    }
    if (color == null) {
      throw new BuiltValueNullFieldError('SubjectGraphConfig', 'color');
    }
  }

  @override
  SubjectGraphConfig rebuild(void Function(SubjectGraphConfigBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SubjectGraphConfigBuilder toBuilder() => new SubjectGraphConfigBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SubjectGraphConfig && thick == other.thick && color == other.color;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, thick.hashCode), color.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('SubjectGraphConfig')
          ..add('thick', thick)
          ..add('color', color))
        .toString();
  }
}

class SubjectGraphConfigBuilder implements Builder<SubjectGraphConfig, SubjectGraphConfigBuilder> {
  _$SubjectGraphConfig _$v;

  int _thick;
  int get thick => _$this._thick;
  set thick(int thick) => _$this._thick = thick;

  int _color;
  int get color => _$this._color;
  set color(int color) => _$this._color = color;

  SubjectGraphConfigBuilder();

  SubjectGraphConfigBuilder get _$this {
    if (_$v != null) {
      _thick = _$v.thick;
      _color = _$v.color;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SubjectGraphConfig other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$SubjectGraphConfig;
  }

  @override
  void update(void Function(SubjectGraphConfigBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$SubjectGraphConfig build() {
    final _$result = _$v ?? new _$SubjectGraphConfig._(thick: thick, color: color);
    replace(_$result);
    return _$result;
  }
}

class _$Semester extends Semester {
  @override
  final String name;
  @override
  final int n;

  factory _$Semester([void Function(SemesterBuilder) updates]) =>
      (new SemesterBuilder()..update(updates)).build();

  _$Semester._({this.name, this.n}) : super._() {
    if (name == null) {
      throw new BuiltValueNullFieldError('Semester', 'name');
    }
  }

  @override
  Semester rebuild(void Function(SemesterBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SemesterBuilder toBuilder() => new SemesterBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Semester && name == other.name && n == other.n;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, name.hashCode), n.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Semester')..add('name', name)..add('n', n)).toString();
  }
}

class SemesterBuilder implements Builder<Semester, SemesterBuilder> {
  _$Semester _$v;

  String _name;
  String get name => _$this._name;
  set name(String name) => _$this._name = name;

  int _n;
  int get n => _$this._n;
  set n(int n) => _$this._n = n;

  SemesterBuilder();

  SemesterBuilder get _$this {
    if (_$v != null) {
      _name = _$v.name;
      _n = _$v.n;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Semester other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Semester;
  }

  @override
  void update(void Function(SemesterBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Semester build() {
    final _$result = _$v ?? new _$Semester._(name: name, n: n);
    replace(_$result);
    return _$result;
  }
}

class _$SettingsState extends SettingsState {
  @override
  final bool noPasswordSaving;
  @override
  final bool noDataSaving;
  @override
  final bool typeSorted;
  @override
  final bool askWhenDelete;
  @override
  final bool showCancelled;
  @override
  final bool deleteDataOnLogout;
  @override
  final bool offlineEnabled;
  @override
  final BuiltMap<String, String> subjectNicks;
  @override
  final bool scrollToSubjectNicks;
  @override
  final bool showCalendarNicksBar;
  @override
  final bool showGradesDiagram;
  @override
  final bool showAllSubjectsAverage;
  @override
  final bool dashboardMarkNewOrChangedEntries;
  @override
  final BuiltMap<int, SubjectGraphConfig> graphConfigs;

  factory _$SettingsState([void Function(SettingsStateBuilder) updates]) =>
      (new SettingsStateBuilder()..update(updates)).build();

  _$SettingsState._(
      {this.noPasswordSaving,
      this.noDataSaving,
      this.typeSorted,
      this.askWhenDelete,
      this.showCancelled,
      this.deleteDataOnLogout,
      this.offlineEnabled,
      this.subjectNicks,
      this.scrollToSubjectNicks,
      this.showCalendarNicksBar,
      this.showGradesDiagram,
      this.showAllSubjectsAverage,
      this.dashboardMarkNewOrChangedEntries,
      this.graphConfigs})
      : super._() {
    if (noPasswordSaving == null) {
      throw new BuiltValueNullFieldError('SettingsState', 'noPasswordSaving');
    }
    if (noDataSaving == null) {
      throw new BuiltValueNullFieldError('SettingsState', 'noDataSaving');
    }
    if (typeSorted == null) {
      throw new BuiltValueNullFieldError('SettingsState', 'typeSorted');
    }
    if (askWhenDelete == null) {
      throw new BuiltValueNullFieldError('SettingsState', 'askWhenDelete');
    }
    if (showCancelled == null) {
      throw new BuiltValueNullFieldError('SettingsState', 'showCancelled');
    }
    if (deleteDataOnLogout == null) {
      throw new BuiltValueNullFieldError('SettingsState', 'deleteDataOnLogout');
    }
    if (offlineEnabled == null) {
      throw new BuiltValueNullFieldError('SettingsState', 'offlineEnabled');
    }
    if (subjectNicks == null) {
      throw new BuiltValueNullFieldError('SettingsState', 'subjectNicks');
    }
    if (showCalendarNicksBar == null) {
      throw new BuiltValueNullFieldError('SettingsState', 'showCalendarNicksBar');
    }
    if (showGradesDiagram == null) {
      throw new BuiltValueNullFieldError('SettingsState', 'showGradesDiagram');
    }
    if (showAllSubjectsAverage == null) {
      throw new BuiltValueNullFieldError('SettingsState', 'showAllSubjectsAverage');
    }
    if (dashboardMarkNewOrChangedEntries == null) {
      throw new BuiltValueNullFieldError('SettingsState', 'dashboardMarkNewOrChangedEntries');
    }
    if (graphConfigs == null) {
      throw new BuiltValueNullFieldError('SettingsState', 'graphConfigs');
    }
  }

  @override
  SettingsState rebuild(void Function(SettingsStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SettingsStateBuilder toBuilder() => new SettingsStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SettingsState &&
        noPasswordSaving == other.noPasswordSaving &&
        noDataSaving == other.noDataSaving &&
        typeSorted == other.typeSorted &&
        askWhenDelete == other.askWhenDelete &&
        showCancelled == other.showCancelled &&
        deleteDataOnLogout == other.deleteDataOnLogout &&
        offlineEnabled == other.offlineEnabled &&
        subjectNicks == other.subjectNicks &&
        scrollToSubjectNicks == other.scrollToSubjectNicks &&
        showCalendarNicksBar == other.showCalendarNicksBar &&
        showGradesDiagram == other.showGradesDiagram &&
        showAllSubjectsAverage == other.showAllSubjectsAverage &&
        dashboardMarkNewOrChangedEntries == other.dashboardMarkNewOrChangedEntries &&
        graphConfigs == other.graphConfigs;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc(
                        $jc(
                            $jc(
                                $jc(
                                    $jc(
                                        $jc(
                                            $jc(
                                                $jc(
                                                    $jc($jc(0, noPasswordSaving.hashCode),
                                                        noDataSaving.hashCode),
                                                    typeSorted.hashCode),
                                                askWhenDelete.hashCode),
                                            showCancelled.hashCode),
                                        deleteDataOnLogout.hashCode),
                                    offlineEnabled.hashCode),
                                subjectNicks.hashCode),
                            scrollToSubjectNicks.hashCode),
                        showCalendarNicksBar.hashCode),
                    showGradesDiagram.hashCode),
                showAllSubjectsAverage.hashCode),
            dashboardMarkNewOrChangedEntries.hashCode),
        graphConfigs.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('SettingsState')
          ..add('noPasswordSaving', noPasswordSaving)
          ..add('noDataSaving', noDataSaving)
          ..add('typeSorted', typeSorted)
          ..add('askWhenDelete', askWhenDelete)
          ..add('showCancelled', showCancelled)
          ..add('deleteDataOnLogout', deleteDataOnLogout)
          ..add('offlineEnabled', offlineEnabled)
          ..add('subjectNicks', subjectNicks)
          ..add('scrollToSubjectNicks', scrollToSubjectNicks)
          ..add('showCalendarNicksBar', showCalendarNicksBar)
          ..add('showGradesDiagram', showGradesDiagram)
          ..add('showAllSubjectsAverage', showAllSubjectsAverage)
          ..add('dashboardMarkNewOrChangedEntries', dashboardMarkNewOrChangedEntries)
          ..add('graphConfigs', graphConfigs))
        .toString();
  }
}

class SettingsStateBuilder implements Builder<SettingsState, SettingsStateBuilder> {
  _$SettingsState _$v;

  bool _noPasswordSaving;
  bool get noPasswordSaving => _$this._noPasswordSaving;
  set noPasswordSaving(bool noPasswordSaving) => _$this._noPasswordSaving = noPasswordSaving;

  bool _noDataSaving;
  bool get noDataSaving => _$this._noDataSaving;
  set noDataSaving(bool noDataSaving) => _$this._noDataSaving = noDataSaving;

  bool _typeSorted;
  bool get typeSorted => _$this._typeSorted;
  set typeSorted(bool typeSorted) => _$this._typeSorted = typeSorted;

  bool _askWhenDelete;
  bool get askWhenDelete => _$this._askWhenDelete;
  set askWhenDelete(bool askWhenDelete) => _$this._askWhenDelete = askWhenDelete;

  bool _showCancelled;
  bool get showCancelled => _$this._showCancelled;
  set showCancelled(bool showCancelled) => _$this._showCancelled = showCancelled;

  bool _deleteDataOnLogout;
  bool get deleteDataOnLogout => _$this._deleteDataOnLogout;
  set deleteDataOnLogout(bool deleteDataOnLogout) =>
      _$this._deleteDataOnLogout = deleteDataOnLogout;

  bool _offlineEnabled;
  bool get offlineEnabled => _$this._offlineEnabled;
  set offlineEnabled(bool offlineEnabled) => _$this._offlineEnabled = offlineEnabled;

  MapBuilder<String, String> _subjectNicks;
  MapBuilder<String, String> get subjectNicks =>
      _$this._subjectNicks ??= new MapBuilder<String, String>();
  set subjectNicks(MapBuilder<String, String> subjectNicks) => _$this._subjectNicks = subjectNicks;

  bool _scrollToSubjectNicks;
  bool get scrollToSubjectNicks => _$this._scrollToSubjectNicks;
  set scrollToSubjectNicks(bool scrollToSubjectNicks) =>
      _$this._scrollToSubjectNicks = scrollToSubjectNicks;

  bool _showCalendarNicksBar;
  bool get showCalendarNicksBar => _$this._showCalendarNicksBar;
  set showCalendarNicksBar(bool showCalendarNicksBar) =>
      _$this._showCalendarNicksBar = showCalendarNicksBar;

  bool _showGradesDiagram;
  bool get showGradesDiagram => _$this._showGradesDiagram;
  set showGradesDiagram(bool showGradesDiagram) => _$this._showGradesDiagram = showGradesDiagram;

  bool _showAllSubjectsAverage;
  bool get showAllSubjectsAverage => _$this._showAllSubjectsAverage;
  set showAllSubjectsAverage(bool showAllSubjectsAverage) =>
      _$this._showAllSubjectsAverage = showAllSubjectsAverage;

  bool _dashboardMarkNewOrChangedEntries;
  bool get dashboardMarkNewOrChangedEntries => _$this._dashboardMarkNewOrChangedEntries;
  set dashboardMarkNewOrChangedEntries(bool dashboardMarkNewOrChangedEntries) =>
      _$this._dashboardMarkNewOrChangedEntries = dashboardMarkNewOrChangedEntries;

  MapBuilder<int, SubjectGraphConfig> _graphConfigs;
  MapBuilder<int, SubjectGraphConfig> get graphConfigs =>
      _$this._graphConfigs ??= new MapBuilder<int, SubjectGraphConfig>();
  set graphConfigs(MapBuilder<int, SubjectGraphConfig> graphConfigs) =>
      _$this._graphConfigs = graphConfigs;

  SettingsStateBuilder() {
    SettingsState._initializeBuilder(this);
  }

  SettingsStateBuilder get _$this {
    if (_$v != null) {
      _noPasswordSaving = _$v.noPasswordSaving;
      _noDataSaving = _$v.noDataSaving;
      _typeSorted = _$v.typeSorted;
      _askWhenDelete = _$v.askWhenDelete;
      _showCancelled = _$v.showCancelled;
      _deleteDataOnLogout = _$v.deleteDataOnLogout;
      _offlineEnabled = _$v.offlineEnabled;
      _subjectNicks = _$v.subjectNicks?.toBuilder();
      _scrollToSubjectNicks = _$v.scrollToSubjectNicks;
      _showCalendarNicksBar = _$v.showCalendarNicksBar;
      _showGradesDiagram = _$v.showGradesDiagram;
      _showAllSubjectsAverage = _$v.showAllSubjectsAverage;
      _dashboardMarkNewOrChangedEntries = _$v.dashboardMarkNewOrChangedEntries;
      _graphConfigs = _$v.graphConfigs?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SettingsState other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$SettingsState;
  }

  @override
  void update(void Function(SettingsStateBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$SettingsState build() {
    _$SettingsState _$result;
    try {
      _$result = _$v ??
          new _$SettingsState._(
              noPasswordSaving: noPasswordSaving,
              noDataSaving: noDataSaving,
              typeSorted: typeSorted,
              askWhenDelete: askWhenDelete,
              showCancelled: showCancelled,
              deleteDataOnLogout: deleteDataOnLogout,
              offlineEnabled: offlineEnabled,
              subjectNicks: subjectNicks.build(),
              scrollToSubjectNicks: scrollToSubjectNicks,
              showCalendarNicksBar: showCalendarNicksBar,
              showGradesDiagram: showGradesDiagram,
              showAllSubjectsAverage: showAllSubjectsAverage,
              dashboardMarkNewOrChangedEntries: dashboardMarkNewOrChangedEntries,
              graphConfigs: graphConfigs.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'subjectNicks';
        subjectNicks.build();

        _$failedField = 'graphConfigs';
        graphConfigs.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError('SettingsState', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$AbsencesState extends AbsencesState {
  @override
  final AbsenceStatistic statistic;
  @override
  final BuiltList<AbsenceGroup> absences;

  factory _$AbsencesState([void Function(AbsencesStateBuilder) updates]) =>
      (new AbsencesStateBuilder()..update(updates)).build();

  _$AbsencesState._({this.statistic, this.absences}) : super._() {
    if (statistic == null) {
      throw new BuiltValueNullFieldError('AbsencesState', 'statistic');
    }
    if (absences == null) {
      throw new BuiltValueNullFieldError('AbsencesState', 'absences');
    }
  }

  @override
  AbsencesState rebuild(void Function(AbsencesStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AbsencesStateBuilder toBuilder() => new AbsencesStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AbsencesState && statistic == other.statistic && absences == other.absences;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, statistic.hashCode), absences.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('AbsencesState')
          ..add('statistic', statistic)
          ..add('absences', absences))
        .toString();
  }
}

class AbsencesStateBuilder implements Builder<AbsencesState, AbsencesStateBuilder> {
  _$AbsencesState _$v;

  AbsenceStatisticBuilder _statistic;
  AbsenceStatisticBuilder get statistic => _$this._statistic ??= new AbsenceStatisticBuilder();
  set statistic(AbsenceStatisticBuilder statistic) => _$this._statistic = statistic;

  ListBuilder<AbsenceGroup> _absences;
  ListBuilder<AbsenceGroup> get absences => _$this._absences ??= new ListBuilder<AbsenceGroup>();
  set absences(ListBuilder<AbsenceGroup> absences) => _$this._absences = absences;

  AbsencesStateBuilder();

  AbsencesStateBuilder get _$this {
    if (_$v != null) {
      _statistic = _$v.statistic?.toBuilder();
      _absences = _$v.absences?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AbsencesState other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$AbsencesState;
  }

  @override
  void update(void Function(AbsencesStateBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$AbsencesState build() {
    _$AbsencesState _$result;
    try {
      _$result =
          _$v ?? new _$AbsencesState._(statistic: statistic.build(), absences: absences.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'statistic';
        statistic.build();
        _$failedField = 'absences';
        absences.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError('AbsencesState', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$CalendarState extends CalendarState {
  @override
  final BuiltMap<DateTime, CalendarDay> days;
  @override
  final DateTime currentMonday;

  factory _$CalendarState([void Function(CalendarStateBuilder) updates]) =>
      (new CalendarStateBuilder()..update(updates)).build();

  _$CalendarState._({this.days, this.currentMonday}) : super._() {
    if (days == null) {
      throw new BuiltValueNullFieldError('CalendarState', 'days');
    }
  }

  @override
  CalendarState rebuild(void Function(CalendarStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CalendarStateBuilder toBuilder() => new CalendarStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CalendarState && days == other.days && currentMonday == other.currentMonday;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, days.hashCode), currentMonday.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('CalendarState')
          ..add('days', days)
          ..add('currentMonday', currentMonday))
        .toString();
  }
}

class CalendarStateBuilder implements Builder<CalendarState, CalendarStateBuilder> {
  _$CalendarState _$v;

  MapBuilder<DateTime, CalendarDay> _days;
  MapBuilder<DateTime, CalendarDay> get days =>
      _$this._days ??= new MapBuilder<DateTime, CalendarDay>();
  set days(MapBuilder<DateTime, CalendarDay> days) => _$this._days = days;

  DateTime _currentMonday;
  DateTime get currentMonday => _$this._currentMonday;
  set currentMonday(DateTime currentMonday) => _$this._currentMonday = currentMonday;

  CalendarStateBuilder() {
    CalendarState._initializeBuilder(this);
  }

  CalendarStateBuilder get _$this {
    if (_$v != null) {
      _days = _$v.days?.toBuilder();
      _currentMonday = _$v.currentMonday;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CalendarState other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$CalendarState;
  }

  @override
  void update(void Function(CalendarStateBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$CalendarState build() {
    _$CalendarState _$result;
    try {
      _$result = _$v ?? new _$CalendarState._(days: days.build(), currentMonday: currentMonday);
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'days';
        days.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError('CalendarState', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$NetworkProtocolState extends NetworkProtocolState {
  @override
  final BuiltList<NetworkProtocolItem> items;

  factory _$NetworkProtocolState([void Function(NetworkProtocolStateBuilder) updates]) =>
      (new NetworkProtocolStateBuilder()..update(updates)).build();

  _$NetworkProtocolState._({this.items}) : super._() {
    if (items == null) {
      throw new BuiltValueNullFieldError('NetworkProtocolState', 'items');
    }
  }

  @override
  NetworkProtocolState rebuild(void Function(NetworkProtocolStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  NetworkProtocolStateBuilder toBuilder() => new NetworkProtocolStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is NetworkProtocolState && items == other.items;
  }

  @override
  int get hashCode {
    return $jf($jc(0, items.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('NetworkProtocolState')..add('items', items)).toString();
  }
}

class NetworkProtocolStateBuilder
    implements Builder<NetworkProtocolState, NetworkProtocolStateBuilder> {
  _$NetworkProtocolState _$v;

  ListBuilder<NetworkProtocolItem> _items;
  ListBuilder<NetworkProtocolItem> get items =>
      _$this._items ??= new ListBuilder<NetworkProtocolItem>();
  set items(ListBuilder<NetworkProtocolItem> items) => _$this._items = items;

  NetworkProtocolStateBuilder();

  NetworkProtocolStateBuilder get _$this {
    if (_$v != null) {
      _items = _$v.items?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(NetworkProtocolState other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$NetworkProtocolState;
  }

  @override
  void update(void Function(NetworkProtocolStateBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$NetworkProtocolState build() {
    _$NetworkProtocolState _$result;
    try {
      _$result = _$v ?? new _$NetworkProtocolState._(items: items.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError('NetworkProtocolState', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$NetworkProtocolItem extends NetworkProtocolItem {
  @override
  final String address;
  @override
  final String parameters;
  @override
  final String response;

  factory _$NetworkProtocolItem([void Function(NetworkProtocolItemBuilder) updates]) =>
      (new NetworkProtocolItemBuilder()..update(updates)).build();

  _$NetworkProtocolItem._({this.address, this.parameters, this.response}) : super._() {
    if (address == null) {
      throw new BuiltValueNullFieldError('NetworkProtocolItem', 'address');
    }
    if (parameters == null) {
      throw new BuiltValueNullFieldError('NetworkProtocolItem', 'parameters');
    }
    if (response == null) {
      throw new BuiltValueNullFieldError('NetworkProtocolItem', 'response');
    }
  }

  @override
  NetworkProtocolItem rebuild(void Function(NetworkProtocolItemBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  NetworkProtocolItemBuilder toBuilder() => new NetworkProtocolItemBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is NetworkProtocolItem &&
        address == other.address &&
        parameters == other.parameters &&
        response == other.response;
  }

  @override
  int get hashCode {
    return $jf($jc($jc($jc(0, address.hashCode), parameters.hashCode), response.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('NetworkProtocolItem')
          ..add('address', address)
          ..add('parameters', parameters)
          ..add('response', response))
        .toString();
  }
}

class NetworkProtocolItemBuilder
    implements Builder<NetworkProtocolItem, NetworkProtocolItemBuilder> {
  _$NetworkProtocolItem _$v;

  String _address;
  String get address => _$this._address;
  set address(String address) => _$this._address = address;

  String _parameters;
  String get parameters => _$this._parameters;
  set parameters(String parameters) => _$this._parameters = parameters;

  String _response;
  String get response => _$this._response;
  set response(String response) => _$this._response = response;

  NetworkProtocolItemBuilder();

  NetworkProtocolItemBuilder get _$this {
    if (_$v != null) {
      _address = _$v.address;
      _parameters = _$v.parameters;
      _response = _$v.response;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(NetworkProtocolItem other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$NetworkProtocolItem;
  }

  @override
  void update(void Function(NetworkProtocolItemBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$NetworkProtocolItem build() {
    final _$result = _$v ??
        new _$NetworkProtocolItem._(address: address, parameters: parameters, response: response);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
