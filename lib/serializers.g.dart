// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'serializers.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializers _$serializers = (new Serializers().toBuilder()
      ..add(Absence.serializer)
      ..add(AbsenceGroup.serializer)
      ..add(AbsenceJustified.serializer)
      ..add(AbsenceStatistic.serializer)
      ..add(AbsencesState.serializer)
      ..add(AppState.serializer)
      ..add(CalendarDay.serializer)
      ..add(CalendarHour.serializer)
      ..add(CalendarState.serializer)
      ..add(Competence.serializer)
      ..add(Config.serializer)
      ..add(DashboardState.serializer)
      ..add(Day.serializer)
      ..add(GradeAll.serializer)
      ..add(GradeDetail.serializer)
      ..add(GradesState.serializer)
      ..add(Homework.serializer)
      ..add(HomeworkType.serializer)
      ..add(LoginState.serializer)
      ..add(Notification.serializer)
      ..add(NotificationState.serializer)
      ..add(Observation.serializer)
      ..add(Semester.serializer)
      ..add(SettingsState.serializer)
      ..add(Subject.serializer)
      ..add(SubjectGraphConfig.serializer)
      ..add(Teacher.serializer)
      ..addBuilderFactory(const FullType(BuiltList, const [const FullType(Absence)]),
          () => new ListBuilder<Absence>())
      ..addBuilderFactory(const FullType(BuiltList, const [const FullType(AbsenceGroup)]),
          () => new ListBuilder<AbsenceGroup>())
      ..addBuilderFactory(const FullType(BuiltList, const [const FullType(CalendarHour)]),
          () => new ListBuilder<CalendarHour>())
      ..addBuilderFactory(const FullType(BuiltList, const [const FullType(Competence)]),
          () => new ListBuilder<Competence>())
      ..addBuilderFactory(const FullType(BuiltList, const [const FullType(Homework)]),
          () => new ListBuilder<Homework>())
      ..addBuilderFactory(const FullType(BuiltList, const [const FullType(Homework)]),
          () => new ListBuilder<Homework>())
      ..addBuilderFactory(const FullType(BuiltList, const [const FullType(HomeworkType)]),
          () => new ListBuilder<HomeworkType>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(Day)]), () => new ListBuilder<Day>())
      ..addBuilderFactory(const FullType(BuiltList, const [const FullType(Notification)]),
          () => new ListBuilder<Notification>())
      ..addBuilderFactory(const FullType(BuiltList, const [const FullType(String)]),
          () => new ListBuilder<String>())
      ..addBuilderFactory(const FullType(BuiltList, const [const FullType(Teacher)]),
          () => new ListBuilder<Teacher>())
      ..addBuilderFactory(const FullType(BuiltList, const [const FullType(Subject)]),
          () => new ListBuilder<Subject>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [const FullType(DateTime), const FullType(CalendarDay)]),
          () => new MapBuilder<DateTime, CalendarDay>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(Semester),
            const FullType(BuiltList, const [const FullType(GradeAll)])
          ]),
          () => new MapBuilder<Semester, BuiltList<GradeAll>>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(Semester),
            const FullType(BuiltList, const [const FullType(GradeDetail)])
          ]),
          () => new MapBuilder<Semester, BuiltList<GradeDetail>>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(Semester),
            const FullType(BuiltList, const [const FullType(Observation)])
          ]),
          () => new MapBuilder<Semester, BuiltList<Observation>>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [const FullType(String), const FullType(String)]),
          () => new MapBuilder<String, String>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [const FullType(int), const FullType(SubjectGraphConfig)]),
          () => new MapBuilder<int, SubjectGraphConfig>()))
    .build();

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
