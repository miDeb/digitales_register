// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const HomeworkType _$a = const HomeworkType._('lessonHomework');
const HomeworkType _$b = const HomeworkType._('gradeGroup');
const HomeworkType _$c = const HomeworkType._('grade');
const HomeworkType _$d = const HomeworkType._('unknown');
const HomeworkType _$e = const HomeworkType._('observation');
const HomeworkType _$f = const HomeworkType._('homework');

HomeworkType _$valueOf2(String name) {
  switch (name) {
    case 'lessonHomework':
      return _$a;
    case 'gradeGroup':
      return _$b;
    case 'grade':
      return _$c;
    case 'unknown':
      return _$d;
    case 'observation':
      return _$e;
    case 'homework':
      return _$f;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<HomeworkType> _$values2 = new BuiltSet<HomeworkType>(const <HomeworkType>[
  _$a,
  _$b,
  _$c,
  _$d,
  _$e,
  _$f,
]);

const AbsenceJustified _$justified = const AbsenceJustified._('justified');
const AbsenceJustified _$notJustified = const AbsenceJustified._('notJustified');
const AbsenceJustified _$forSchool = const AbsenceJustified._('forSchool');
const AbsenceJustified _$notYetJustified = const AbsenceJustified._('notYetJustified');

AbsenceJustified _$valueOf(String name) {
  switch (name) {
    case 'justified':
      return _$justified;
    case 'notJustified':
      return _$notJustified;
    case 'forSchool':
      return _$forSchool;
    case 'notYetJustified':
      return _$notYetJustified;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<AbsenceJustified> _$values = new BuiltSet<AbsenceJustified>(const <AbsenceJustified>[
  _$justified,
  _$notJustified,
  _$forSchool,
  _$notYetJustified,
]);

Serializer<Day> _$daySerializer = new _$DaySerializer();
Serializer<Homework> _$homeworkSerializer = new _$HomeworkSerializer();
Serializer<HomeworkType> _$homeworkTypeSerializer = new _$HomeworkTypeSerializer();
Serializer<Notification> _$notificationSerializer = new _$NotificationSerializer();
Serializer<Subject> _$subjectSerializer = new _$SubjectSerializer();
Serializer<Observation> _$observationSerializer = new _$ObservationSerializer();
Serializer<GradeAll> _$gradeAllSerializer = new _$GradeAllSerializer();
Serializer<GradeDetail> _$gradeDetailSerializer = new _$GradeDetailSerializer();
Serializer<Competence> _$competenceSerializer = new _$CompetenceSerializer();
Serializer<AbsenceGroup> _$absenceGroupSerializer = new _$AbsenceGroupSerializer();
Serializer<AbsenceStatistic> _$absenceStatisticSerializer = new _$AbsenceStatisticSerializer();
Serializer<Absence> _$absenceSerializer = new _$AbsenceSerializer();
Serializer<AbsenceJustified> _$absenceJustifiedSerializer = new _$AbsenceJustifiedSerializer();
Serializer<CalendarDay> _$calendarDaySerializer = new _$CalendarDaySerializer();
Serializer<CalendarHour> _$calendarHourSerializer = new _$CalendarHourSerializer();
Serializer<Teacher> _$teacherSerializer = new _$TeacherSerializer();

class _$DaySerializer implements StructuredSerializer<Day> {
  @override
  final Iterable<Type> types = const [Day, _$Day];
  @override
  final String wireName = 'Day';

  @override
  Iterable<Object> serialize(Serializers serializers, Day object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'homework',
      serializers.serialize(object.homework,
          specifiedType: const FullType(BuiltList, const [const FullType(Homework)])),
      'deletedHomework',
      serializers.serialize(object.deletedHomework,
          specifiedType: const FullType(BuiltList, const [const FullType(Homework)])),
      'date',
      serializers.serialize(object.date, specifiedType: const FullType(DateTime)),
      'lastRequested',
      serializers.serialize(object.lastRequested, specifiedType: const FullType(DateTime)),
    ];

    return result;
  }

  @override
  Day deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new DayBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'homework':
          result.homework.replace(serializers.deserialize(value,
                  specifiedType: const FullType(BuiltList, const [const FullType(Homework)]))
              as BuiltList<dynamic>);
          break;
        case 'deletedHomework':
          result.deletedHomework.replace(serializers.deserialize(value,
                  specifiedType: const FullType(BuiltList, const [const FullType(Homework)]))
              as BuiltList<dynamic>);
          break;
        case 'date':
          result.date =
              serializers.deserialize(value, specifiedType: const FullType(DateTime)) as DateTime;
          break;
        case 'lastRequested':
          result.lastRequested =
              serializers.deserialize(value, specifiedType: const FullType(DateTime)) as DateTime;
          break;
      }
    }

    return result.build();
  }
}

class _$HomeworkSerializer implements StructuredSerializer<Homework> {
  @override
  final Iterable<Type> types = const [Homework, _$Homework];
  @override
  final String wireName = 'Homework';

  @override
  Iterable<Object> serialize(Serializers serializers, Homework object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'deleted',
      serializers.serialize(object.deleted, specifiedType: const FullType(bool)),
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(int)),
      'isNew',
      serializers.serialize(object.isNew, specifiedType: const FullType(bool)),
      'isChanged',
      serializers.serialize(object.isChanged, specifiedType: const FullType(bool)),
      'title',
      serializers.serialize(object.title, specifiedType: const FullType(String)),
      'subtitle',
      serializers.serialize(object.subtitle, specifiedType: const FullType(String)),
      'warning',
      serializers.serialize(object.warning, specifiedType: const FullType(bool)),
      'checkable',
      serializers.serialize(object.checkable, specifiedType: const FullType(bool)),
      'checked',
      serializers.serialize(object.checked, specifiedType: const FullType(bool)),
      'deleteable',
      serializers.serialize(object.deleteable, specifiedType: const FullType(bool)),
      'type',
      serializers.serialize(object.type, specifiedType: const FullType(HomeworkType)),
      'firstSeen',
      serializers.serialize(object.firstSeen, specifiedType: const FullType(DateTime)),
    ];
    if (object.label != null) {
      result
        ..add('label')
        ..add(serializers.serialize(object.label, specifiedType: const FullType(String)));
    }
    if (object.gradeFormatted != null) {
      result
        ..add('gradeFormatted')
        ..add(serializers.serialize(object.gradeFormatted, specifiedType: const FullType(String)));
    }
    if (object.grade != null) {
      result
        ..add('grade')
        ..add(serializers.serialize(object.grade, specifiedType: const FullType(String)));
    }
    if (object.previousVersion != null) {
      result
        ..add('previousVersion')
        ..add(
            serializers.serialize(object.previousVersion, specifiedType: const FullType(Homework)));
    }
    if (object.lastNotSeen != null) {
      result
        ..add('lastNotSeen')
        ..add(serializers.serialize(object.lastNotSeen, specifiedType: const FullType(DateTime)));
    }
    return result;
  }

  @override
  Homework deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new HomeworkBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'deleted':
          result.deleted =
              serializers.deserialize(value, specifiedType: const FullType(bool)) as bool;
          break;
        case 'id':
          result.id = serializers.deserialize(value, specifiedType: const FullType(int)) as int;
          break;
        case 'isNew':
          result.isNew =
              serializers.deserialize(value, specifiedType: const FullType(bool)) as bool;
          break;
        case 'isChanged':
          result.isChanged =
              serializers.deserialize(value, specifiedType: const FullType(bool)) as bool;
          break;
        case 'title':
          result.title =
              serializers.deserialize(value, specifiedType: const FullType(String)) as String;
          break;
        case 'subtitle':
          result.subtitle =
              serializers.deserialize(value, specifiedType: const FullType(String)) as String;
          break;
        case 'label':
          result.label =
              serializers.deserialize(value, specifiedType: const FullType(String)) as String;
          break;
        case 'gradeFormatted':
          result.gradeFormatted =
              serializers.deserialize(value, specifiedType: const FullType(String)) as String;
          break;
        case 'grade':
          result.grade =
              serializers.deserialize(value, specifiedType: const FullType(String)) as String;
          break;
        case 'warning':
          result.warning =
              serializers.deserialize(value, specifiedType: const FullType(bool)) as bool;
          break;
        case 'checkable':
          result.checkable =
              serializers.deserialize(value, specifiedType: const FullType(bool)) as bool;
          break;
        case 'checked':
          result.checked =
              serializers.deserialize(value, specifiedType: const FullType(bool)) as bool;
          break;
        case 'deleteable':
          result.deleteable =
              serializers.deserialize(value, specifiedType: const FullType(bool)) as bool;
          break;
        case 'type':
          result.type = serializers.deserialize(value, specifiedType: const FullType(HomeworkType))
              as HomeworkType;
          break;
        case 'previousVersion':
          result.previousVersion.replace(
              serializers.deserialize(value, specifiedType: const FullType(Homework)) as Homework);
          break;
        case 'lastNotSeen':
          result.lastNotSeen =
              serializers.deserialize(value, specifiedType: const FullType(DateTime)) as DateTime;
          break;
        case 'firstSeen':
          result.firstSeen =
              serializers.deserialize(value, specifiedType: const FullType(DateTime)) as DateTime;
          break;
      }
    }

    return result.build();
  }
}

class _$HomeworkTypeSerializer implements PrimitiveSerializer<HomeworkType> {
  @override
  final Iterable<Type> types = const <Type>[HomeworkType];
  @override
  final String wireName = 'HomeworkType';

  @override
  Object serialize(Serializers serializers, HomeworkType object,
          {FullType specifiedType = FullType.unspecified}) =>
      object.name;

  @override
  HomeworkType deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      HomeworkType.valueOf(serialized as String);
}

class _$NotificationSerializer implements StructuredSerializer<Notification> {
  @override
  final Iterable<Type> types = const [Notification, _$Notification];
  @override
  final String wireName = 'Notification';

  @override
  Iterable<Object> serialize(Serializers serializers, Notification object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(int)),
      'title',
      serializers.serialize(object.title, specifiedType: const FullType(String)),
      'timeSent',
      serializers.serialize(object.timeSent, specifiedType: const FullType(DateTime)),
    ];
    if (object.subTitle != null) {
      result
        ..add('subTitle')
        ..add(serializers.serialize(object.subTitle, specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  Notification deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new NotificationBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'id':
          result.id = serializers.deserialize(value, specifiedType: const FullType(int)) as int;
          break;
        case 'title':
          result.title =
              serializers.deserialize(value, specifiedType: const FullType(String)) as String;
          break;
        case 'subTitle':
          result.subTitle =
              serializers.deserialize(value, specifiedType: const FullType(String)) as String;
          break;
        case 'timeSent':
          result.timeSent =
              serializers.deserialize(value, specifiedType: const FullType(DateTime)) as DateTime;
          break;
      }
    }

    return result.build();
  }
}

class _$SubjectSerializer implements StructuredSerializer<Subject> {
  @override
  final Iterable<Type> types = const [Subject, _$Subject];
  @override
  final String wireName = 'Subject';

  @override
  Iterable<Object> serialize(Serializers serializers, Subject object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'gradesAll',
      serializers.serialize(object.gradesAll,
          specifiedType: const FullType(BuiltMap, const [
            const FullType(Semester),
            const FullType(BuiltList, const [const FullType(GradeAll)])
          ])),
      'grades',
      serializers.serialize(object.grades,
          specifiedType: const FullType(BuiltMap, const [
            const FullType(Semester),
            const FullType(BuiltList, const [const FullType(GradeDetail)])
          ])),
      'observations',
      serializers.serialize(object.observations,
          specifiedType: const FullType(BuiltMap, const [
            const FullType(Semester),
            const FullType(BuiltList, const [const FullType(Observation)])
          ])),
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(int)),
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  Subject deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new SubjectBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'gradesAll':
          result.gradesAll.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltMap, const [
                const FullType(Semester),
                const FullType(BuiltList, const [const FullType(GradeAll)])
              ])) as BuiltMap<dynamic, dynamic>);
          break;
        case 'grades':
          result.grades.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltMap, const [
                const FullType(Semester),
                const FullType(BuiltList, const [const FullType(GradeDetail)])
              ])) as BuiltMap<dynamic, dynamic>);
          break;
        case 'observations':
          result.observations.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltMap, const [
                const FullType(Semester),
                const FullType(BuiltList, const [const FullType(Observation)])
              ])) as BuiltMap<dynamic, dynamic>);
          break;
        case 'id':
          result.id = serializers.deserialize(value, specifiedType: const FullType(int)) as int;
          break;
        case 'name':
          result.name =
              serializers.deserialize(value, specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$ObservationSerializer implements StructuredSerializer<Observation> {
  @override
  final Iterable<Type> types = const [Observation, _$Observation];
  @override
  final String wireName = 'Observation';

  @override
  Iterable<Object> serialize(Serializers serializers, Observation object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'typeName',
      serializers.serialize(object.typeName, specifiedType: const FullType(String)),
      'created',
      serializers.serialize(object.created, specifiedType: const FullType(String)),
      'note',
      serializers.serialize(object.note, specifiedType: const FullType(String)),
      'date',
      serializers.serialize(object.date, specifiedType: const FullType(DateTime)),
      'cancelled',
      serializers.serialize(object.cancelled, specifiedType: const FullType(bool)),
    ];

    return result;
  }

  @override
  Observation deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ObservationBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'typeName':
          result.typeName =
              serializers.deserialize(value, specifiedType: const FullType(String)) as String;
          break;
        case 'created':
          result.created =
              serializers.deserialize(value, specifiedType: const FullType(String)) as String;
          break;
        case 'note':
          result.note =
              serializers.deserialize(value, specifiedType: const FullType(String)) as String;
          break;
        case 'date':
          result.date =
              serializers.deserialize(value, specifiedType: const FullType(DateTime)) as DateTime;
          break;
        case 'cancelled':
          result.cancelled =
              serializers.deserialize(value, specifiedType: const FullType(bool)) as bool;
          break;
      }
    }

    return result.build();
  }
}

class _$GradeAllSerializer implements StructuredSerializer<GradeAll> {
  @override
  final Iterable<Type> types = const [GradeAll, _$GradeAll];
  @override
  final String wireName = 'GradeAll';

  @override
  Iterable<Object> serialize(Serializers serializers, GradeAll object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'grade',
      serializers.serialize(object.grade, specifiedType: const FullType(int)),
      'weightPercentage',
      serializers.serialize(object.weightPercentage, specifiedType: const FullType(int)),
      'date',
      serializers.serialize(object.date, specifiedType: const FullType(DateTime)),
      'type',
      serializers.serialize(object.type, specifiedType: const FullType(String)),
      'cancelled',
      serializers.serialize(object.cancelled, specifiedType: const FullType(bool)),
    ];

    return result;
  }

  @override
  GradeAll deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new GradeAllBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'grade':
          result.grade = serializers.deserialize(value, specifiedType: const FullType(int)) as int;
          break;
        case 'weightPercentage':
          result.weightPercentage =
              serializers.deserialize(value, specifiedType: const FullType(int)) as int;
          break;
        case 'date':
          result.date =
              serializers.deserialize(value, specifiedType: const FullType(DateTime)) as DateTime;
          break;
        case 'type':
          result.type =
              serializers.deserialize(value, specifiedType: const FullType(String)) as String;
          break;
        case 'cancelled':
          result.cancelled =
              serializers.deserialize(value, specifiedType: const FullType(bool)) as bool;
          break;
      }
    }

    return result.build();
  }
}

class _$GradeDetailSerializer implements StructuredSerializer<GradeDetail> {
  @override
  final Iterable<Type> types = const [GradeDetail, _$GradeDetail];
  @override
  final String wireName = 'GradeDetail';

  @override
  Iterable<Object> serialize(Serializers serializers, GradeDetail object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(int)),
      'competences',
      serializers.serialize(object.competences,
          specifiedType: const FullType(BuiltList, const [const FullType(Competence)])),
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
      'created',
      serializers.serialize(object.created, specifiedType: const FullType(String)),
      'grade',
      serializers.serialize(object.grade, specifiedType: const FullType(int)),
      'weightPercentage',
      serializers.serialize(object.weightPercentage, specifiedType: const FullType(int)),
      'date',
      serializers.serialize(object.date, specifiedType: const FullType(DateTime)),
      'type',
      serializers.serialize(object.type, specifiedType: const FullType(String)),
      'cancelled',
      serializers.serialize(object.cancelled, specifiedType: const FullType(bool)),
    ];

    return result;
  }

  @override
  GradeDetail deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new GradeDetailBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'id':
          result.id = serializers.deserialize(value, specifiedType: const FullType(int)) as int;
          break;
        case 'competences':
          result.competences.replace(serializers.deserialize(value,
                  specifiedType: const FullType(BuiltList, const [const FullType(Competence)]))
              as BuiltList<dynamic>);
          break;
        case 'name':
          result.name =
              serializers.deserialize(value, specifiedType: const FullType(String)) as String;
          break;
        case 'created':
          result.created =
              serializers.deserialize(value, specifiedType: const FullType(String)) as String;
          break;
        case 'grade':
          result.grade = serializers.deserialize(value, specifiedType: const FullType(int)) as int;
          break;
        case 'weightPercentage':
          result.weightPercentage =
              serializers.deserialize(value, specifiedType: const FullType(int)) as int;
          break;
        case 'date':
          result.date =
              serializers.deserialize(value, specifiedType: const FullType(DateTime)) as DateTime;
          break;
        case 'type':
          result.type =
              serializers.deserialize(value, specifiedType: const FullType(String)) as String;
          break;
        case 'cancelled':
          result.cancelled =
              serializers.deserialize(value, specifiedType: const FullType(bool)) as bool;
          break;
      }
    }

    return result.build();
  }
}

class _$CompetenceSerializer implements StructuredSerializer<Competence> {
  @override
  final Iterable<Type> types = const [Competence, _$Competence];
  @override
  final String wireName = 'Competence';

  @override
  Iterable<Object> serialize(Serializers serializers, Competence object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'typeName',
      serializers.serialize(object.typeName, specifiedType: const FullType(String)),
      'grade',
      serializers.serialize(object.grade, specifiedType: const FullType(int)),
    ];

    return result;
  }

  @override
  Competence deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new CompetenceBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'typeName':
          result.typeName =
              serializers.deserialize(value, specifiedType: const FullType(String)) as String;
          break;
        case 'grade':
          result.grade = serializers.deserialize(value, specifiedType: const FullType(int)) as int;
          break;
      }
    }

    return result.build();
  }
}

class _$AbsenceGroupSerializer implements StructuredSerializer<AbsenceGroup> {
  @override
  final Iterable<Type> types = const [AbsenceGroup, _$AbsenceGroup];
  @override
  final String wireName = 'AbsenceGroup';

  @override
  Iterable<Object> serialize(Serializers serializers, AbsenceGroup object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'justified',
      serializers.serialize(object.justified, specifiedType: const FullType(AbsenceJustified)),
      'hours',
      serializers.serialize(object.hours, specifiedType: const FullType(int)),
      'minutes',
      serializers.serialize(object.minutes, specifiedType: const FullType(int)),
      'absences',
      serializers.serialize(object.absences,
          specifiedType: const FullType(BuiltList, const [const FullType(Absence)])),
    ];
    if (object.reason != null) {
      result
        ..add('reason')
        ..add(serializers.serialize(object.reason, specifiedType: const FullType(String)));
    }
    if (object.reasonSignature != null) {
      result
        ..add('reasonSignature')
        ..add(serializers.serialize(object.reasonSignature, specifiedType: const FullType(String)));
    }
    if (object.reasonTimestamp != null) {
      result
        ..add('reasonTimestamp')
        ..add(
            serializers.serialize(object.reasonTimestamp, specifiedType: const FullType(DateTime)));
    }
    return result;
  }

  @override
  AbsenceGroup deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new AbsenceGroupBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'reason':
          result.reason =
              serializers.deserialize(value, specifiedType: const FullType(String)) as String;
          break;
        case 'reasonSignature':
          result.reasonSignature =
              serializers.deserialize(value, specifiedType: const FullType(String)) as String;
          break;
        case 'reasonTimestamp':
          result.reasonTimestamp =
              serializers.deserialize(value, specifiedType: const FullType(DateTime)) as DateTime;
          break;
        case 'justified':
          result.justified = serializers.deserialize(value,
              specifiedType: const FullType(AbsenceJustified)) as AbsenceJustified;
          break;
        case 'hours':
          result.hours = serializers.deserialize(value, specifiedType: const FullType(int)) as int;
          break;
        case 'minutes':
          result.minutes =
              serializers.deserialize(value, specifiedType: const FullType(int)) as int;
          break;
        case 'absences':
          result.absences.replace(serializers.deserialize(value,
                  specifiedType: const FullType(BuiltList, const [const FullType(Absence)]))
              as BuiltList<dynamic>);
          break;
      }
    }

    return result.build();
  }
}

class _$AbsenceStatisticSerializer implements StructuredSerializer<AbsenceStatistic> {
  @override
  final Iterable<Type> types = const [AbsenceStatistic, _$AbsenceStatistic];
  @override
  final String wireName = 'AbsenceStatistic';

  @override
  Iterable<Object> serialize(Serializers serializers, AbsenceStatistic object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'counter',
      serializers.serialize(object.counter, specifiedType: const FullType(int)),
      'counterForSchool',
      serializers.serialize(object.counterForSchool, specifiedType: const FullType(int)),
      'delayed',
      serializers.serialize(object.delayed, specifiedType: const FullType(int)),
      'justified',
      serializers.serialize(object.justified, specifiedType: const FullType(int)),
      'notJustified',
      serializers.serialize(object.notJustified, specifiedType: const FullType(int)),
      'percentage',
      serializers.serialize(object.percentage, specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  AbsenceStatistic deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new AbsenceStatisticBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'counter':
          result.counter =
              serializers.deserialize(value, specifiedType: const FullType(int)) as int;
          break;
        case 'counterForSchool':
          result.counterForSchool =
              serializers.deserialize(value, specifiedType: const FullType(int)) as int;
          break;
        case 'delayed':
          result.delayed =
              serializers.deserialize(value, specifiedType: const FullType(int)) as int;
          break;
        case 'justified':
          result.justified =
              serializers.deserialize(value, specifiedType: const FullType(int)) as int;
          break;
        case 'notJustified':
          result.notJustified =
              serializers.deserialize(value, specifiedType: const FullType(int)) as int;
          break;
        case 'percentage':
          result.percentage =
              serializers.deserialize(value, specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$AbsenceSerializer implements StructuredSerializer<Absence> {
  @override
  final Iterable<Type> types = const [Absence, _$Absence];
  @override
  final String wireName = 'Absence';

  @override
  Iterable<Object> serialize(Serializers serializers, Absence object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'minutes',
      serializers.serialize(object.minutes, specifiedType: const FullType(int)),
      'minutesCameTooLate',
      serializers.serialize(object.minutesCameTooLate, specifiedType: const FullType(int)),
      'minutesLeftTooEarly',
      serializers.serialize(object.minutesLeftTooEarly, specifiedType: const FullType(int)),
      'date',
      serializers.serialize(object.date, specifiedType: const FullType(DateTime)),
      'hour',
      serializers.serialize(object.hour, specifiedType: const FullType(int)),
    ];

    return result;
  }

  @override
  Absence deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new AbsenceBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'minutes':
          result.minutes =
              serializers.deserialize(value, specifiedType: const FullType(int)) as int;
          break;
        case 'minutesCameTooLate':
          result.minutesCameTooLate =
              serializers.deserialize(value, specifiedType: const FullType(int)) as int;
          break;
        case 'minutesLeftTooEarly':
          result.minutesLeftTooEarly =
              serializers.deserialize(value, specifiedType: const FullType(int)) as int;
          break;
        case 'date':
          result.date =
              serializers.deserialize(value, specifiedType: const FullType(DateTime)) as DateTime;
          break;
        case 'hour':
          result.hour = serializers.deserialize(value, specifiedType: const FullType(int)) as int;
          break;
      }
    }

    return result.build();
  }
}

class _$AbsenceJustifiedSerializer implements PrimitiveSerializer<AbsenceJustified> {
  @override
  final Iterable<Type> types = const <Type>[AbsenceJustified];
  @override
  final String wireName = 'AbsenceJustified';

  @override
  Object serialize(Serializers serializers, AbsenceJustified object,
          {FullType specifiedType = FullType.unspecified}) =>
      object.name;

  @override
  AbsenceJustified deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AbsenceJustified.valueOf(serialized as String);
}

class _$CalendarDaySerializer implements StructuredSerializer<CalendarDay> {
  @override
  final Iterable<Type> types = const [CalendarDay, _$CalendarDay];
  @override
  final String wireName = 'CalendarDay';

  @override
  Iterable<Object> serialize(Serializers serializers, CalendarDay object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'date',
      serializers.serialize(object.date, specifiedType: const FullType(DateTime)),
      'hours',
      serializers.serialize(object.hours,
          specifiedType: const FullType(BuiltList, const [const FullType(CalendarHour)])),
    ];

    return result;
  }

  @override
  CalendarDay deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new CalendarDayBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'date':
          result.date =
              serializers.deserialize(value, specifiedType: const FullType(DateTime)) as DateTime;
          break;
        case 'hours':
          result.hours.replace(serializers.deserialize(value,
                  specifiedType: const FullType(BuiltList, const [const FullType(CalendarHour)]))
              as BuiltList<dynamic>);
          break;
      }
    }

    return result.build();
  }
}

class _$CalendarHourSerializer implements StructuredSerializer<CalendarHour> {
  @override
  final Iterable<Type> types = const [CalendarHour, _$CalendarHour];
  @override
  final String wireName = 'CalendarHour';

  @override
  Iterable<Object> serialize(Serializers serializers, CalendarHour object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'fromHour',
      serializers.serialize(object.fromHour, specifiedType: const FullType(int)),
      'toHour',
      serializers.serialize(object.toHour, specifiedType: const FullType(int)),
      'rooms',
      serializers.serialize(object.rooms,
          specifiedType: const FullType(BuiltList, const [const FullType(String)])),
      'subject',
      serializers.serialize(object.subject, specifiedType: const FullType(String)),
      'teachers',
      serializers.serialize(object.teachers,
          specifiedType: const FullType(BuiltList, const [const FullType(Teacher)])),
    ];
    if (object.description != null) {
      result
        ..add('description')
        ..add(serializers.serialize(object.description, specifiedType: const FullType(String)));
    }
    if (object.exam != null) {
      result
        ..add('exam')
        ..add(serializers.serialize(object.exam, specifiedType: const FullType(String)));
    }
    if (object.homework != null) {
      result
        ..add('homework')
        ..add(serializers.serialize(object.homework, specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  CalendarHour deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new CalendarHourBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'fromHour':
          result.fromHour =
              serializers.deserialize(value, specifiedType: const FullType(int)) as int;
          break;
        case 'toHour':
          result.toHour = serializers.deserialize(value, specifiedType: const FullType(int)) as int;
          break;
        case 'rooms':
          result.rooms.replace(serializers.deserialize(value,
                  specifiedType: const FullType(BuiltList, const [const FullType(String)]))
              as BuiltList<dynamic>);
          break;
        case 'description':
          result.description =
              serializers.deserialize(value, specifiedType: const FullType(String)) as String;
          break;
        case 'subject':
          result.subject =
              serializers.deserialize(value, specifiedType: const FullType(String)) as String;
          break;
        case 'exam':
          result.exam =
              serializers.deserialize(value, specifiedType: const FullType(String)) as String;
          break;
        case 'homework':
          result.homework =
              serializers.deserialize(value, specifiedType: const FullType(String)) as String;
          break;
        case 'teachers':
          result.teachers.replace(serializers.deserialize(value,
                  specifiedType: const FullType(BuiltList, const [const FullType(Teacher)]))
              as BuiltList<dynamic>);
          break;
      }
    }

    return result.build();
  }
}

class _$TeacherSerializer implements StructuredSerializer<Teacher> {
  @override
  final Iterable<Type> types = const [Teacher, _$Teacher];
  @override
  final String wireName = 'Teacher';

  @override
  Iterable<Object> serialize(Serializers serializers, Teacher object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'firstName',
      serializers.serialize(object.firstName, specifiedType: const FullType(String)),
      'lastName',
      serializers.serialize(object.lastName, specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  Teacher deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new TeacherBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'firstName':
          result.firstName =
              serializers.deserialize(value, specifiedType: const FullType(String)) as String;
          break;
        case 'lastName':
          result.lastName =
              serializers.deserialize(value, specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$Day extends Day {
  @override
  final BuiltList<Homework> homework;
  @override
  final BuiltList<Homework> deletedHomework;
  @override
  final DateTime date;
  @override
  final DateTime lastRequested;

  factory _$Day([void Function(DayBuilder) updates]) => (new DayBuilder()..update(updates)).build();

  _$Day._({this.homework, this.deletedHomework, this.date, this.lastRequested}) : super._() {
    if (homework == null) {
      throw new BuiltValueNullFieldError('Day', 'homework');
    }
    if (deletedHomework == null) {
      throw new BuiltValueNullFieldError('Day', 'deletedHomework');
    }
    if (date == null) {
      throw new BuiltValueNullFieldError('Day', 'date');
    }
    if (lastRequested == null) {
      throw new BuiltValueNullFieldError('Day', 'lastRequested');
    }
  }

  @override
  Day rebuild(void Function(DayBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  DayBuilder toBuilder() => new DayBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Day &&
        homework == other.homework &&
        deletedHomework == other.deletedHomework &&
        date == other.date &&
        lastRequested == other.lastRequested;
  }

  @override
  int get hashCode {
    return $jf($jc($jc($jc($jc(0, homework.hashCode), deletedHomework.hashCode), date.hashCode),
        lastRequested.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Day')
          ..add('homework', homework)
          ..add('deletedHomework', deletedHomework)
          ..add('date', date)
          ..add('lastRequested', lastRequested))
        .toString();
  }
}

class DayBuilder implements Builder<Day, DayBuilder> {
  _$Day _$v;

  ListBuilder<Homework> _homework;
  ListBuilder<Homework> get homework => _$this._homework ??= new ListBuilder<Homework>();
  set homework(ListBuilder<Homework> homework) => _$this._homework = homework;

  ListBuilder<Homework> _deletedHomework;
  ListBuilder<Homework> get deletedHomework =>
      _$this._deletedHomework ??= new ListBuilder<Homework>();
  set deletedHomework(ListBuilder<Homework> deletedHomework) =>
      _$this._deletedHomework = deletedHomework;

  DateTime _date;
  DateTime get date => _$this._date;
  set date(DateTime date) => _$this._date = date;

  DateTime _lastRequested;
  DateTime get lastRequested => _$this._lastRequested;
  set lastRequested(DateTime lastRequested) => _$this._lastRequested = lastRequested;

  DayBuilder() {
    Day._initializeBuilder(this);
  }

  DayBuilder get _$this {
    if (_$v != null) {
      _homework = _$v.homework?.toBuilder();
      _deletedHomework = _$v.deletedHomework?.toBuilder();
      _date = _$v.date;
      _lastRequested = _$v.lastRequested;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Day other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Day;
  }

  @override
  void update(void Function(DayBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Day build() {
    _$Day _$result;
    try {
      _$result = _$v ??
          new _$Day._(
              homework: homework.build(),
              deletedHomework: deletedHomework.build(),
              date: date,
              lastRequested: lastRequested);
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'homework';
        homework.build();
        _$failedField = 'deletedHomework';
        deletedHomework.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError('Day', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$Homework extends Homework {
  @override
  final bool deleted;
  @override
  final int id;
  @override
  final bool isNew;
  @override
  final bool isChanged;
  @override
  final String title;
  @override
  final String subtitle;
  @override
  final String label;
  @override
  final String gradeFormatted;
  @override
  final String grade;
  @override
  final bool warning;
  @override
  final bool checkable;
  @override
  final bool checked;
  @override
  final bool deleteable;
  @override
  final HomeworkType type;
  @override
  final Homework previousVersion;
  @override
  final DateTime lastNotSeen;
  @override
  final DateTime firstSeen;

  factory _$Homework([void Function(HomeworkBuilder) updates]) =>
      (new HomeworkBuilder()..update(updates)).build();

  _$Homework._(
      {this.deleted,
      this.id,
      this.isNew,
      this.isChanged,
      this.title,
      this.subtitle,
      this.label,
      this.gradeFormatted,
      this.grade,
      this.warning,
      this.checkable,
      this.checked,
      this.deleteable,
      this.type,
      this.previousVersion,
      this.lastNotSeen,
      this.firstSeen})
      : super._() {
    if (deleted == null) {
      throw new BuiltValueNullFieldError('Homework', 'deleted');
    }
    if (id == null) {
      throw new BuiltValueNullFieldError('Homework', 'id');
    }
    if (isNew == null) {
      throw new BuiltValueNullFieldError('Homework', 'isNew');
    }
    if (isChanged == null) {
      throw new BuiltValueNullFieldError('Homework', 'isChanged');
    }
    if (title == null) {
      throw new BuiltValueNullFieldError('Homework', 'title');
    }
    if (subtitle == null) {
      throw new BuiltValueNullFieldError('Homework', 'subtitle');
    }
    if (warning == null) {
      throw new BuiltValueNullFieldError('Homework', 'warning');
    }
    if (checkable == null) {
      throw new BuiltValueNullFieldError('Homework', 'checkable');
    }
    if (checked == null) {
      throw new BuiltValueNullFieldError('Homework', 'checked');
    }
    if (deleteable == null) {
      throw new BuiltValueNullFieldError('Homework', 'deleteable');
    }
    if (type == null) {
      throw new BuiltValueNullFieldError('Homework', 'type');
    }
    if (firstSeen == null) {
      throw new BuiltValueNullFieldError('Homework', 'firstSeen');
    }
  }

  @override
  Homework rebuild(void Function(HomeworkBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  HomeworkBuilder toBuilder() => new HomeworkBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Homework &&
        deleted == other.deleted &&
        id == other.id &&
        isNew == other.isNew &&
        isChanged == other.isChanged &&
        title == other.title &&
        subtitle == other.subtitle &&
        label == other.label &&
        gradeFormatted == other.gradeFormatted &&
        grade == other.grade &&
        warning == other.warning &&
        checkable == other.checkable &&
        checked == other.checked &&
        deleteable == other.deleteable &&
        type == other.type &&
        previousVersion == other.previousVersion &&
        lastNotSeen == other.lastNotSeen &&
        firstSeen == other.firstSeen;
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
                                                    $jc(
                                                        $jc(
                                                            $jc(
                                                                $jc($jc(0, deleted.hashCode),
                                                                    id.hashCode),
                                                                isNew.hashCode),
                                                            isChanged.hashCode),
                                                        title.hashCode),
                                                    subtitle.hashCode),
                                                label.hashCode),
                                            gradeFormatted.hashCode),
                                        grade.hashCode),
                                    warning.hashCode),
                                checkable.hashCode),
                            checked.hashCode),
                        deleteable.hashCode),
                    type.hashCode),
                previousVersion.hashCode),
            lastNotSeen.hashCode),
        firstSeen.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Homework')
          ..add('deleted', deleted)
          ..add('id', id)
          ..add('isNew', isNew)
          ..add('isChanged', isChanged)
          ..add('title', title)
          ..add('subtitle', subtitle)
          ..add('label', label)
          ..add('gradeFormatted', gradeFormatted)
          ..add('grade', grade)
          ..add('warning', warning)
          ..add('checkable', checkable)
          ..add('checked', checked)
          ..add('deleteable', deleteable)
          ..add('type', type)
          ..add('previousVersion', previousVersion)
          ..add('lastNotSeen', lastNotSeen)
          ..add('firstSeen', firstSeen))
        .toString();
  }
}

class HomeworkBuilder implements Builder<Homework, HomeworkBuilder> {
  _$Homework _$v;

  bool _deleted;
  bool get deleted => _$this._deleted;
  set deleted(bool deleted) => _$this._deleted = deleted;

  int _id;
  int get id => _$this._id;
  set id(int id) => _$this._id = id;

  bool _isNew;
  bool get isNew => _$this._isNew;
  set isNew(bool isNew) => _$this._isNew = isNew;

  bool _isChanged;
  bool get isChanged => _$this._isChanged;
  set isChanged(bool isChanged) => _$this._isChanged = isChanged;

  String _title;
  String get title => _$this._title;
  set title(String title) => _$this._title = title;

  String _subtitle;
  String get subtitle => _$this._subtitle;
  set subtitle(String subtitle) => _$this._subtitle = subtitle;

  String _label;
  String get label => _$this._label;
  set label(String label) => _$this._label = label;

  String _gradeFormatted;
  String get gradeFormatted => _$this._gradeFormatted;
  set gradeFormatted(String gradeFormatted) => _$this._gradeFormatted = gradeFormatted;

  String _grade;
  String get grade => _$this._grade;
  set grade(String grade) => _$this._grade = grade;

  bool _warning;
  bool get warning => _$this._warning;
  set warning(bool warning) => _$this._warning = warning;

  bool _checkable;
  bool get checkable => _$this._checkable;
  set checkable(bool checkable) => _$this._checkable = checkable;

  bool _checked;
  bool get checked => _$this._checked;
  set checked(bool checked) => _$this._checked = checked;

  bool _deleteable;
  bool get deleteable => _$this._deleteable;
  set deleteable(bool deleteable) => _$this._deleteable = deleteable;

  HomeworkType _type;
  HomeworkType get type => _$this._type;
  set type(HomeworkType type) => _$this._type = type;

  HomeworkBuilder _previousVersion;
  HomeworkBuilder get previousVersion => _$this._previousVersion ??= new HomeworkBuilder();
  set previousVersion(HomeworkBuilder previousVersion) => _$this._previousVersion = previousVersion;

  DateTime _lastNotSeen;
  DateTime get lastNotSeen => _$this._lastNotSeen;
  set lastNotSeen(DateTime lastNotSeen) => _$this._lastNotSeen = lastNotSeen;

  DateTime _firstSeen;
  DateTime get firstSeen => _$this._firstSeen;
  set firstSeen(DateTime firstSeen) => _$this._firstSeen = firstSeen;

  HomeworkBuilder() {
    Homework._initializeBuilder(this);
  }

  HomeworkBuilder get _$this {
    if (_$v != null) {
      _deleted = _$v.deleted;
      _id = _$v.id;
      _isNew = _$v.isNew;
      _isChanged = _$v.isChanged;
      _title = _$v.title;
      _subtitle = _$v.subtitle;
      _label = _$v.label;
      _gradeFormatted = _$v.gradeFormatted;
      _grade = _$v.grade;
      _warning = _$v.warning;
      _checkable = _$v.checkable;
      _checked = _$v.checked;
      _deleteable = _$v.deleteable;
      _type = _$v.type;
      _previousVersion = _$v.previousVersion?.toBuilder();
      _lastNotSeen = _$v.lastNotSeen;
      _firstSeen = _$v.firstSeen;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Homework other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Homework;
  }

  @override
  void update(void Function(HomeworkBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Homework build() {
    _$Homework _$result;
    try {
      _$result = _$v ??
          new _$Homework._(
              deleted: deleted,
              id: id,
              isNew: isNew,
              isChanged: isChanged,
              title: title,
              subtitle: subtitle,
              label: label,
              gradeFormatted: gradeFormatted,
              grade: grade,
              warning: warning,
              checkable: checkable,
              checked: checked,
              deleteable: deleteable,
              type: type,
              previousVersion: _previousVersion?.build(),
              lastNotSeen: lastNotSeen,
              firstSeen: firstSeen);
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'previousVersion';
        _previousVersion?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError('Homework', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$Notification extends Notification {
  @override
  final int id;
  @override
  final String title;
  @override
  final String subTitle;
  @override
  final DateTime timeSent;

  factory _$Notification([void Function(NotificationBuilder) updates]) =>
      (new NotificationBuilder()..update(updates)).build();

  _$Notification._({this.id, this.title, this.subTitle, this.timeSent}) : super._() {
    if (id == null) {
      throw new BuiltValueNullFieldError('Notification', 'id');
    }
    if (title == null) {
      throw new BuiltValueNullFieldError('Notification', 'title');
    }
    if (timeSent == null) {
      throw new BuiltValueNullFieldError('Notification', 'timeSent');
    }
  }

  @override
  Notification rebuild(void Function(NotificationBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  NotificationBuilder toBuilder() => new NotificationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Notification &&
        id == other.id &&
        title == other.title &&
        subTitle == other.subTitle &&
        timeSent == other.timeSent;
  }

  @override
  int get hashCode {
    return $jf(
        $jc($jc($jc($jc(0, id.hashCode), title.hashCode), subTitle.hashCode), timeSent.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Notification')
          ..add('id', id)
          ..add('title', title)
          ..add('subTitle', subTitle)
          ..add('timeSent', timeSent))
        .toString();
  }
}

class NotificationBuilder implements Builder<Notification, NotificationBuilder> {
  _$Notification _$v;

  int _id;
  int get id => _$this._id;
  set id(int id) => _$this._id = id;

  String _title;
  String get title => _$this._title;
  set title(String title) => _$this._title = title;

  String _subTitle;
  String get subTitle => _$this._subTitle;
  set subTitle(String subTitle) => _$this._subTitle = subTitle;

  DateTime _timeSent;
  DateTime get timeSent => _$this._timeSent;
  set timeSent(DateTime timeSent) => _$this._timeSent = timeSent;

  NotificationBuilder();

  NotificationBuilder get _$this {
    if (_$v != null) {
      _id = _$v.id;
      _title = _$v.title;
      _subTitle = _$v.subTitle;
      _timeSent = _$v.timeSent;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Notification other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Notification;
  }

  @override
  void update(void Function(NotificationBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Notification build() {
    final _$result =
        _$v ?? new _$Notification._(id: id, title: title, subTitle: subTitle, timeSent: timeSent);
    replace(_$result);
    return _$result;
  }
}

class _$Subject extends Subject {
  @override
  final BuiltMap<Semester, BuiltList<GradeAll>> gradesAll;
  @override
  final BuiltMap<Semester, BuiltList<GradeDetail>> grades;
  @override
  final BuiltMap<Semester, BuiltList<Observation>> observations;
  @override
  final int id;
  @override
  final String name;

  factory _$Subject([void Function(SubjectBuilder) updates]) =>
      (new SubjectBuilder()..update(updates)).build();

  _$Subject._({this.gradesAll, this.grades, this.observations, this.id, this.name}) : super._() {
    if (gradesAll == null) {
      throw new BuiltValueNullFieldError('Subject', 'gradesAll');
    }
    if (grades == null) {
      throw new BuiltValueNullFieldError('Subject', 'grades');
    }
    if (observations == null) {
      throw new BuiltValueNullFieldError('Subject', 'observations');
    }
    if (id == null) {
      throw new BuiltValueNullFieldError('Subject', 'id');
    }
    if (name == null) {
      throw new BuiltValueNullFieldError('Subject', 'name');
    }
  }

  @override
  Subject rebuild(void Function(SubjectBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  SubjectBuilder toBuilder() => new SubjectBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Subject &&
        gradesAll == other.gradesAll &&
        grades == other.grades &&
        observations == other.observations &&
        id == other.id &&
        name == other.name;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc($jc($jc(0, gradesAll.hashCode), grades.hashCode), observations.hashCode),
            id.hashCode),
        name.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Subject')
          ..add('gradesAll', gradesAll)
          ..add('grades', grades)
          ..add('observations', observations)
          ..add('id', id)
          ..add('name', name))
        .toString();
  }
}

class SubjectBuilder implements Builder<Subject, SubjectBuilder> {
  _$Subject _$v;

  MapBuilder<Semester, BuiltList<GradeAll>> _gradesAll;
  MapBuilder<Semester, BuiltList<GradeAll>> get gradesAll =>
      _$this._gradesAll ??= new MapBuilder<Semester, BuiltList<GradeAll>>();
  set gradesAll(MapBuilder<Semester, BuiltList<GradeAll>> gradesAll) =>
      _$this._gradesAll = gradesAll;

  MapBuilder<Semester, BuiltList<GradeDetail>> _grades;
  MapBuilder<Semester, BuiltList<GradeDetail>> get grades =>
      _$this._grades ??= new MapBuilder<Semester, BuiltList<GradeDetail>>();
  set grades(MapBuilder<Semester, BuiltList<GradeDetail>> grades) => _$this._grades = grades;

  MapBuilder<Semester, BuiltList<Observation>> _observations;
  MapBuilder<Semester, BuiltList<Observation>> get observations =>
      _$this._observations ??= new MapBuilder<Semester, BuiltList<Observation>>();
  set observations(MapBuilder<Semester, BuiltList<Observation>> observations) =>
      _$this._observations = observations;

  int _id;
  int get id => _$this._id;
  set id(int id) => _$this._id = id;

  String _name;
  String get name => _$this._name;
  set name(String name) => _$this._name = name;

  SubjectBuilder();

  SubjectBuilder get _$this {
    if (_$v != null) {
      _gradesAll = _$v.gradesAll?.toBuilder();
      _grades = _$v.grades?.toBuilder();
      _observations = _$v.observations?.toBuilder();
      _id = _$v.id;
      _name = _$v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Subject other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Subject;
  }

  @override
  void update(void Function(SubjectBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Subject build() {
    _$Subject _$result;
    try {
      _$result = _$v ??
          new _$Subject._(
              gradesAll: gradesAll.build(),
              grades: grades.build(),
              observations: observations.build(),
              id: id,
              name: name);
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'gradesAll';
        gradesAll.build();
        _$failedField = 'grades';
        grades.build();
        _$failedField = 'observations';
        observations.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError('Subject', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$Observation extends Observation {
  @override
  final String typeName;
  @override
  final String created;
  @override
  final String note;
  @override
  final DateTime date;
  @override
  final bool cancelled;

  factory _$Observation([void Function(ObservationBuilder) updates]) =>
      (new ObservationBuilder()..update(updates)).build();

  _$Observation._({this.typeName, this.created, this.note, this.date, this.cancelled}) : super._() {
    if (typeName == null) {
      throw new BuiltValueNullFieldError('Observation', 'typeName');
    }
    if (created == null) {
      throw new BuiltValueNullFieldError('Observation', 'created');
    }
    if (note == null) {
      throw new BuiltValueNullFieldError('Observation', 'note');
    }
    if (date == null) {
      throw new BuiltValueNullFieldError('Observation', 'date');
    }
    if (cancelled == null) {
      throw new BuiltValueNullFieldError('Observation', 'cancelled');
    }
  }

  @override
  Observation rebuild(void Function(ObservationBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ObservationBuilder toBuilder() => new ObservationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Observation &&
        typeName == other.typeName &&
        created == other.created &&
        note == other.note &&
        date == other.date &&
        cancelled == other.cancelled;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc($jc($jc(0, typeName.hashCode), created.hashCode), note.hashCode), date.hashCode),
        cancelled.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Observation')
          ..add('typeName', typeName)
          ..add('created', created)
          ..add('note', note)
          ..add('date', date)
          ..add('cancelled', cancelled))
        .toString();
  }
}

class ObservationBuilder implements Builder<Observation, ObservationBuilder> {
  _$Observation _$v;

  String _typeName;
  String get typeName => _$this._typeName;
  set typeName(String typeName) => _$this._typeName = typeName;

  String _created;
  String get created => _$this._created;
  set created(String created) => _$this._created = created;

  String _note;
  String get note => _$this._note;
  set note(String note) => _$this._note = note;

  DateTime _date;
  DateTime get date => _$this._date;
  set date(DateTime date) => _$this._date = date;

  bool _cancelled;
  bool get cancelled => _$this._cancelled;
  set cancelled(bool cancelled) => _$this._cancelled = cancelled;

  ObservationBuilder();

  ObservationBuilder get _$this {
    if (_$v != null) {
      _typeName = _$v.typeName;
      _created = _$v.created;
      _note = _$v.note;
      _date = _$v.date;
      _cancelled = _$v.cancelled;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Observation other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Observation;
  }

  @override
  void update(void Function(ObservationBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Observation build() {
    final _$result = _$v ??
        new _$Observation._(
            typeName: typeName, created: created, note: note, date: date, cancelled: cancelled);
    replace(_$result);
    return _$result;
  }
}

class _$GradeAll extends GradeAll {
  @override
  final int grade;
  @override
  final int weightPercentage;
  @override
  final DateTime date;
  @override
  final String type;
  @override
  final bool cancelled;

  factory _$GradeAll([void Function(GradeAllBuilder) updates]) =>
      (new GradeAllBuilder()..update(updates)).build();

  _$GradeAll._({this.grade, this.weightPercentage, this.date, this.type, this.cancelled})
      : super._() {
    if (grade == null) {
      throw new BuiltValueNullFieldError('GradeAll', 'grade');
    }
    if (weightPercentage == null) {
      throw new BuiltValueNullFieldError('GradeAll', 'weightPercentage');
    }
    if (date == null) {
      throw new BuiltValueNullFieldError('GradeAll', 'date');
    }
    if (type == null) {
      throw new BuiltValueNullFieldError('GradeAll', 'type');
    }
    if (cancelled == null) {
      throw new BuiltValueNullFieldError('GradeAll', 'cancelled');
    }
  }

  @override
  GradeAll rebuild(void Function(GradeAllBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GradeAllBuilder toBuilder() => new GradeAllBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GradeAll &&
        grade == other.grade &&
        weightPercentage == other.weightPercentage &&
        date == other.date &&
        type == other.type &&
        cancelled == other.cancelled;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc($jc($jc(0, grade.hashCode), weightPercentage.hashCode), date.hashCode),
            type.hashCode),
        cancelled.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('GradeAll')
          ..add('grade', grade)
          ..add('weightPercentage', weightPercentage)
          ..add('date', date)
          ..add('type', type)
          ..add('cancelled', cancelled))
        .toString();
  }
}

class GradeAllBuilder implements Builder<GradeAll, GradeAllBuilder> {
  _$GradeAll _$v;

  int _grade;
  int get grade => _$this._grade;
  set grade(int grade) => _$this._grade = grade;

  int _weightPercentage;
  int get weightPercentage => _$this._weightPercentage;
  set weightPercentage(int weightPercentage) => _$this._weightPercentage = weightPercentage;

  DateTime _date;
  DateTime get date => _$this._date;
  set date(DateTime date) => _$this._date = date;

  String _type;
  String get type => _$this._type;
  set type(String type) => _$this._type = type;

  bool _cancelled;
  bool get cancelled => _$this._cancelled;
  set cancelled(bool cancelled) => _$this._cancelled = cancelled;

  GradeAllBuilder();

  GradeAllBuilder get _$this {
    if (_$v != null) {
      _grade = _$v.grade;
      _weightPercentage = _$v.weightPercentage;
      _date = _$v.date;
      _type = _$v.type;
      _cancelled = _$v.cancelled;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GradeAll other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$GradeAll;
  }

  @override
  void update(void Function(GradeAllBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$GradeAll build() {
    final _$result = _$v ??
        new _$GradeAll._(
            grade: grade,
            weightPercentage: weightPercentage,
            date: date,
            type: type,
            cancelled: cancelled);
    replace(_$result);
    return _$result;
  }
}

class _$GradeDetail extends GradeDetail {
  @override
  final int id;
  @override
  final BuiltList<Competence> competences;
  @override
  final String name;
  @override
  final String created;
  @override
  final int grade;
  @override
  final int weightPercentage;
  @override
  final DateTime date;
  @override
  final String type;
  @override
  final bool cancelled;

  factory _$GradeDetail([void Function(GradeDetailBuilder) updates]) =>
      (new GradeDetailBuilder()..update(updates)).build();

  _$GradeDetail._(
      {this.id,
      this.competences,
      this.name,
      this.created,
      this.grade,
      this.weightPercentage,
      this.date,
      this.type,
      this.cancelled})
      : super._() {
    if (id == null) {
      throw new BuiltValueNullFieldError('GradeDetail', 'id');
    }
    if (competences == null) {
      throw new BuiltValueNullFieldError('GradeDetail', 'competences');
    }
    if (name == null) {
      throw new BuiltValueNullFieldError('GradeDetail', 'name');
    }
    if (created == null) {
      throw new BuiltValueNullFieldError('GradeDetail', 'created');
    }
    if (grade == null) {
      throw new BuiltValueNullFieldError('GradeDetail', 'grade');
    }
    if (weightPercentage == null) {
      throw new BuiltValueNullFieldError('GradeDetail', 'weightPercentage');
    }
    if (date == null) {
      throw new BuiltValueNullFieldError('GradeDetail', 'date');
    }
    if (type == null) {
      throw new BuiltValueNullFieldError('GradeDetail', 'type');
    }
    if (cancelled == null) {
      throw new BuiltValueNullFieldError('GradeDetail', 'cancelled');
    }
  }

  @override
  GradeDetail rebuild(void Function(GradeDetailBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GradeDetailBuilder toBuilder() => new GradeDetailBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GradeDetail &&
        id == other.id &&
        competences == other.competences &&
        name == other.name &&
        created == other.created &&
        grade == other.grade &&
        weightPercentage == other.weightPercentage &&
        date == other.date &&
        type == other.type &&
        cancelled == other.cancelled;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc(
                        $jc($jc($jc($jc(0, id.hashCode), competences.hashCode), name.hashCode),
                            created.hashCode),
                        grade.hashCode),
                    weightPercentage.hashCode),
                date.hashCode),
            type.hashCode),
        cancelled.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('GradeDetail')
          ..add('id', id)
          ..add('competences', competences)
          ..add('name', name)
          ..add('created', created)
          ..add('grade', grade)
          ..add('weightPercentage', weightPercentage)
          ..add('date', date)
          ..add('type', type)
          ..add('cancelled', cancelled))
        .toString();
  }
}

class GradeDetailBuilder implements Builder<GradeDetail, GradeDetailBuilder> {
  _$GradeDetail _$v;

  int _id;
  int get id => _$this._id;
  set id(int id) => _$this._id = id;

  ListBuilder<Competence> _competences;
  ListBuilder<Competence> get competences => _$this._competences ??= new ListBuilder<Competence>();
  set competences(ListBuilder<Competence> competences) => _$this._competences = competences;

  String _name;
  String get name => _$this._name;
  set name(String name) => _$this._name = name;

  String _created;
  String get created => _$this._created;
  set created(String created) => _$this._created = created;

  int _grade;
  int get grade => _$this._grade;
  set grade(int grade) => _$this._grade = grade;

  int _weightPercentage;
  int get weightPercentage => _$this._weightPercentage;
  set weightPercentage(int weightPercentage) => _$this._weightPercentage = weightPercentage;

  DateTime _date;
  DateTime get date => _$this._date;
  set date(DateTime date) => _$this._date = date;

  String _type;
  String get type => _$this._type;
  set type(String type) => _$this._type = type;

  bool _cancelled;
  bool get cancelled => _$this._cancelled;
  set cancelled(bool cancelled) => _$this._cancelled = cancelled;

  GradeDetailBuilder();

  GradeDetailBuilder get _$this {
    if (_$v != null) {
      _id = _$v.id;
      _competences = _$v.competences?.toBuilder();
      _name = _$v.name;
      _created = _$v.created;
      _grade = _$v.grade;
      _weightPercentage = _$v.weightPercentage;
      _date = _$v.date;
      _type = _$v.type;
      _cancelled = _$v.cancelled;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GradeDetail other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$GradeDetail;
  }

  @override
  void update(void Function(GradeDetailBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$GradeDetail build() {
    _$GradeDetail _$result;
    try {
      _$result = _$v ??
          new _$GradeDetail._(
              id: id,
              competences: competences.build(),
              name: name,
              created: created,
              grade: grade,
              weightPercentage: weightPercentage,
              date: date,
              type: type,
              cancelled: cancelled);
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'competences';
        competences.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError('GradeDetail', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$Competence extends Competence {
  @override
  final String typeName;
  @override
  final int grade;

  factory _$Competence([void Function(CompetenceBuilder) updates]) =>
      (new CompetenceBuilder()..update(updates)).build();

  _$Competence._({this.typeName, this.grade}) : super._() {
    if (typeName == null) {
      throw new BuiltValueNullFieldError('Competence', 'typeName');
    }
    if (grade == null) {
      throw new BuiltValueNullFieldError('Competence', 'grade');
    }
  }

  @override
  Competence rebuild(void Function(CompetenceBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CompetenceBuilder toBuilder() => new CompetenceBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Competence && typeName == other.typeName && grade == other.grade;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, typeName.hashCode), grade.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Competence')
          ..add('typeName', typeName)
          ..add('grade', grade))
        .toString();
  }
}

class CompetenceBuilder implements Builder<Competence, CompetenceBuilder> {
  _$Competence _$v;

  String _typeName;
  String get typeName => _$this._typeName;
  set typeName(String typeName) => _$this._typeName = typeName;

  int _grade;
  int get grade => _$this._grade;
  set grade(int grade) => _$this._grade = grade;

  CompetenceBuilder();

  CompetenceBuilder get _$this {
    if (_$v != null) {
      _typeName = _$v.typeName;
      _grade = _$v.grade;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Competence other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Competence;
  }

  @override
  void update(void Function(CompetenceBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Competence build() {
    final _$result = _$v ?? new _$Competence._(typeName: typeName, grade: grade);
    replace(_$result);
    return _$result;
  }
}

class _$AbsenceGroup extends AbsenceGroup {
  @override
  final String reason;
  @override
  final String reasonSignature;
  @override
  final DateTime reasonTimestamp;
  @override
  final AbsenceJustified justified;
  @override
  final int hours;
  @override
  final int minutes;
  @override
  final BuiltList<Absence> absences;

  factory _$AbsenceGroup([void Function(AbsenceGroupBuilder) updates]) =>
      (new AbsenceGroupBuilder()..update(updates)).build();

  _$AbsenceGroup._(
      {this.reason,
      this.reasonSignature,
      this.reasonTimestamp,
      this.justified,
      this.hours,
      this.minutes,
      this.absences})
      : super._() {
    if (justified == null) {
      throw new BuiltValueNullFieldError('AbsenceGroup', 'justified');
    }
    if (hours == null) {
      throw new BuiltValueNullFieldError('AbsenceGroup', 'hours');
    }
    if (minutes == null) {
      throw new BuiltValueNullFieldError('AbsenceGroup', 'minutes');
    }
    if (absences == null) {
      throw new BuiltValueNullFieldError('AbsenceGroup', 'absences');
    }
  }

  @override
  AbsenceGroup rebuild(void Function(AbsenceGroupBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AbsenceGroupBuilder toBuilder() => new AbsenceGroupBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AbsenceGroup &&
        reason == other.reason &&
        reasonSignature == other.reasonSignature &&
        reasonTimestamp == other.reasonTimestamp &&
        justified == other.justified &&
        hours == other.hours &&
        minutes == other.minutes &&
        absences == other.absences;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc($jc($jc(0, reason.hashCode), reasonSignature.hashCode),
                        reasonTimestamp.hashCode),
                    justified.hashCode),
                hours.hashCode),
            minutes.hashCode),
        absences.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('AbsenceGroup')
          ..add('reason', reason)
          ..add('reasonSignature', reasonSignature)
          ..add('reasonTimestamp', reasonTimestamp)
          ..add('justified', justified)
          ..add('hours', hours)
          ..add('minutes', minutes)
          ..add('absences', absences))
        .toString();
  }
}

class AbsenceGroupBuilder implements Builder<AbsenceGroup, AbsenceGroupBuilder> {
  _$AbsenceGroup _$v;

  String _reason;
  String get reason => _$this._reason;
  set reason(String reason) => _$this._reason = reason;

  String _reasonSignature;
  String get reasonSignature => _$this._reasonSignature;
  set reasonSignature(String reasonSignature) => _$this._reasonSignature = reasonSignature;

  DateTime _reasonTimestamp;
  DateTime get reasonTimestamp => _$this._reasonTimestamp;
  set reasonTimestamp(DateTime reasonTimestamp) => _$this._reasonTimestamp = reasonTimestamp;

  AbsenceJustified _justified;
  AbsenceJustified get justified => _$this._justified;
  set justified(AbsenceJustified justified) => _$this._justified = justified;

  int _hours;
  int get hours => _$this._hours;
  set hours(int hours) => _$this._hours = hours;

  int _minutes;
  int get minutes => _$this._minutes;
  set minutes(int minutes) => _$this._minutes = minutes;

  ListBuilder<Absence> _absences;
  ListBuilder<Absence> get absences => _$this._absences ??= new ListBuilder<Absence>();
  set absences(ListBuilder<Absence> absences) => _$this._absences = absences;

  AbsenceGroupBuilder();

  AbsenceGroupBuilder get _$this {
    if (_$v != null) {
      _reason = _$v.reason;
      _reasonSignature = _$v.reasonSignature;
      _reasonTimestamp = _$v.reasonTimestamp;
      _justified = _$v.justified;
      _hours = _$v.hours;
      _minutes = _$v.minutes;
      _absences = _$v.absences?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AbsenceGroup other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$AbsenceGroup;
  }

  @override
  void update(void Function(AbsenceGroupBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$AbsenceGroup build() {
    _$AbsenceGroup _$result;
    try {
      _$result = _$v ??
          new _$AbsenceGroup._(
              reason: reason,
              reasonSignature: reasonSignature,
              reasonTimestamp: reasonTimestamp,
              justified: justified,
              hours: hours,
              minutes: minutes,
              absences: absences.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'absences';
        absences.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError('AbsenceGroup', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$AbsenceStatistic extends AbsenceStatistic {
  @override
  final int counter;
  @override
  final int counterForSchool;
  @override
  final int delayed;
  @override
  final int justified;
  @override
  final int notJustified;
  @override
  final String percentage;

  factory _$AbsenceStatistic([void Function(AbsenceStatisticBuilder) updates]) =>
      (new AbsenceStatisticBuilder()..update(updates)).build();

  _$AbsenceStatistic._(
      {this.counter,
      this.counterForSchool,
      this.delayed,
      this.justified,
      this.notJustified,
      this.percentage})
      : super._() {
    if (counter == null) {
      throw new BuiltValueNullFieldError('AbsenceStatistic', 'counter');
    }
    if (counterForSchool == null) {
      throw new BuiltValueNullFieldError('AbsenceStatistic', 'counterForSchool');
    }
    if (delayed == null) {
      throw new BuiltValueNullFieldError('AbsenceStatistic', 'delayed');
    }
    if (justified == null) {
      throw new BuiltValueNullFieldError('AbsenceStatistic', 'justified');
    }
    if (notJustified == null) {
      throw new BuiltValueNullFieldError('AbsenceStatistic', 'notJustified');
    }
    if (percentage == null) {
      throw new BuiltValueNullFieldError('AbsenceStatistic', 'percentage');
    }
  }

  @override
  AbsenceStatistic rebuild(void Function(AbsenceStatisticBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AbsenceStatisticBuilder toBuilder() => new AbsenceStatisticBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AbsenceStatistic &&
        counter == other.counter &&
        counterForSchool == other.counterForSchool &&
        delayed == other.delayed &&
        justified == other.justified &&
        notJustified == other.notJustified &&
        percentage == other.percentage;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc($jc($jc($jc(0, counter.hashCode), counterForSchool.hashCode), delayed.hashCode),
                justified.hashCode),
            notJustified.hashCode),
        percentage.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('AbsenceStatistic')
          ..add('counter', counter)
          ..add('counterForSchool', counterForSchool)
          ..add('delayed', delayed)
          ..add('justified', justified)
          ..add('notJustified', notJustified)
          ..add('percentage', percentage))
        .toString();
  }
}

class AbsenceStatisticBuilder implements Builder<AbsenceStatistic, AbsenceStatisticBuilder> {
  _$AbsenceStatistic _$v;

  int _counter;
  int get counter => _$this._counter;
  set counter(int counter) => _$this._counter = counter;

  int _counterForSchool;
  int get counterForSchool => _$this._counterForSchool;
  set counterForSchool(int counterForSchool) => _$this._counterForSchool = counterForSchool;

  int _delayed;
  int get delayed => _$this._delayed;
  set delayed(int delayed) => _$this._delayed = delayed;

  int _justified;
  int get justified => _$this._justified;
  set justified(int justified) => _$this._justified = justified;

  int _notJustified;
  int get notJustified => _$this._notJustified;
  set notJustified(int notJustified) => _$this._notJustified = notJustified;

  String _percentage;
  String get percentage => _$this._percentage;
  set percentage(String percentage) => _$this._percentage = percentage;

  AbsenceStatisticBuilder();

  AbsenceStatisticBuilder get _$this {
    if (_$v != null) {
      _counter = _$v.counter;
      _counterForSchool = _$v.counterForSchool;
      _delayed = _$v.delayed;
      _justified = _$v.justified;
      _notJustified = _$v.notJustified;
      _percentage = _$v.percentage;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AbsenceStatistic other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$AbsenceStatistic;
  }

  @override
  void update(void Function(AbsenceStatisticBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$AbsenceStatistic build() {
    final _$result = _$v ??
        new _$AbsenceStatistic._(
            counter: counter,
            counterForSchool: counterForSchool,
            delayed: delayed,
            justified: justified,
            notJustified: notJustified,
            percentage: percentage);
    replace(_$result);
    return _$result;
  }
}

class _$Absence extends Absence {
  @override
  final int minutes;
  @override
  final int minutesCameTooLate;
  @override
  final int minutesLeftTooEarly;
  @override
  final DateTime date;
  @override
  final int hour;

  factory _$Absence([void Function(AbsenceBuilder) updates]) =>
      (new AbsenceBuilder()..update(updates)).build();

  _$Absence._(
      {this.minutes, this.minutesCameTooLate, this.minutesLeftTooEarly, this.date, this.hour})
      : super._() {
    if (minutes == null) {
      throw new BuiltValueNullFieldError('Absence', 'minutes');
    }
    if (minutesCameTooLate == null) {
      throw new BuiltValueNullFieldError('Absence', 'minutesCameTooLate');
    }
    if (minutesLeftTooEarly == null) {
      throw new BuiltValueNullFieldError('Absence', 'minutesLeftTooEarly');
    }
    if (date == null) {
      throw new BuiltValueNullFieldError('Absence', 'date');
    }
    if (hour == null) {
      throw new BuiltValueNullFieldError('Absence', 'hour');
    }
  }

  @override
  Absence rebuild(void Function(AbsenceBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  AbsenceBuilder toBuilder() => new AbsenceBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Absence &&
        minutes == other.minutes &&
        minutesCameTooLate == other.minutesCameTooLate &&
        minutesLeftTooEarly == other.minutesLeftTooEarly &&
        date == other.date &&
        hour == other.hour;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc($jc($jc(0, minutes.hashCode), minutesCameTooLate.hashCode),
                minutesLeftTooEarly.hashCode),
            date.hashCode),
        hour.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Absence')
          ..add('minutes', minutes)
          ..add('minutesCameTooLate', minutesCameTooLate)
          ..add('minutesLeftTooEarly', minutesLeftTooEarly)
          ..add('date', date)
          ..add('hour', hour))
        .toString();
  }
}

class AbsenceBuilder implements Builder<Absence, AbsenceBuilder> {
  _$Absence _$v;

  int _minutes;
  int get minutes => _$this._minutes;
  set minutes(int minutes) => _$this._minutes = minutes;

  int _minutesCameTooLate;
  int get minutesCameTooLate => _$this._minutesCameTooLate;
  set minutesCameTooLate(int minutesCameTooLate) => _$this._minutesCameTooLate = minutesCameTooLate;

  int _minutesLeftTooEarly;
  int get minutesLeftTooEarly => _$this._minutesLeftTooEarly;
  set minutesLeftTooEarly(int minutesLeftTooEarly) =>
      _$this._minutesLeftTooEarly = minutesLeftTooEarly;

  DateTime _date;
  DateTime get date => _$this._date;
  set date(DateTime date) => _$this._date = date;

  int _hour;
  int get hour => _$this._hour;
  set hour(int hour) => _$this._hour = hour;

  AbsenceBuilder();

  AbsenceBuilder get _$this {
    if (_$v != null) {
      _minutes = _$v.minutes;
      _minutesCameTooLate = _$v.minutesCameTooLate;
      _minutesLeftTooEarly = _$v.minutesLeftTooEarly;
      _date = _$v.date;
      _hour = _$v.hour;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Absence other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Absence;
  }

  @override
  void update(void Function(AbsenceBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Absence build() {
    final _$result = _$v ??
        new _$Absence._(
            minutes: minutes,
            minutesCameTooLate: minutesCameTooLate,
            minutesLeftTooEarly: minutesLeftTooEarly,
            date: date,
            hour: hour);
    replace(_$result);
    return _$result;
  }
}

class _$CalendarDay extends CalendarDay {
  @override
  final DateTime date;
  @override
  final BuiltList<CalendarHour> hours;

  factory _$CalendarDay([void Function(CalendarDayBuilder) updates]) =>
      (new CalendarDayBuilder()..update(updates)).build();

  _$CalendarDay._({this.date, this.hours}) : super._() {
    if (date == null) {
      throw new BuiltValueNullFieldError('CalendarDay', 'date');
    }
    if (hours == null) {
      throw new BuiltValueNullFieldError('CalendarDay', 'hours');
    }
  }

  @override
  CalendarDay rebuild(void Function(CalendarDayBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CalendarDayBuilder toBuilder() => new CalendarDayBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CalendarDay && date == other.date && hours == other.hours;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, date.hashCode), hours.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('CalendarDay')..add('date', date)..add('hours', hours))
        .toString();
  }
}

class CalendarDayBuilder implements Builder<CalendarDay, CalendarDayBuilder> {
  _$CalendarDay _$v;

  DateTime _date;
  DateTime get date => _$this._date;
  set date(DateTime date) => _$this._date = date;

  ListBuilder<CalendarHour> _hours;
  ListBuilder<CalendarHour> get hours => _$this._hours ??= new ListBuilder<CalendarHour>();
  set hours(ListBuilder<CalendarHour> hours) => _$this._hours = hours;

  CalendarDayBuilder();

  CalendarDayBuilder get _$this {
    if (_$v != null) {
      _date = _$v.date;
      _hours = _$v.hours?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CalendarDay other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$CalendarDay;
  }

  @override
  void update(void Function(CalendarDayBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$CalendarDay build() {
    _$CalendarDay _$result;
    try {
      _$result = _$v ?? new _$CalendarDay._(date: date, hours: hours.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'hours';
        hours.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError('CalendarDay', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$CalendarHour extends CalendarHour {
  @override
  final int fromHour;
  @override
  final int toHour;
  @override
  final BuiltList<String> rooms;
  @override
  final String description;
  @override
  final String subject;
  @override
  final String exam;
  @override
  final String homework;
  @override
  final BuiltList<Teacher> teachers;

  factory _$CalendarHour([void Function(CalendarHourBuilder) updates]) =>
      (new CalendarHourBuilder()..update(updates)).build();

  _$CalendarHour._(
      {this.fromHour,
      this.toHour,
      this.rooms,
      this.description,
      this.subject,
      this.exam,
      this.homework,
      this.teachers})
      : super._() {
    if (fromHour == null) {
      throw new BuiltValueNullFieldError('CalendarHour', 'fromHour');
    }
    if (toHour == null) {
      throw new BuiltValueNullFieldError('CalendarHour', 'toHour');
    }
    if (rooms == null) {
      throw new BuiltValueNullFieldError('CalendarHour', 'rooms');
    }
    if (subject == null) {
      throw new BuiltValueNullFieldError('CalendarHour', 'subject');
    }
    if (teachers == null) {
      throw new BuiltValueNullFieldError('CalendarHour', 'teachers');
    }
  }

  @override
  CalendarHour rebuild(void Function(CalendarHourBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CalendarHourBuilder toBuilder() => new CalendarHourBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CalendarHour &&
        fromHour == other.fromHour &&
        toHour == other.toHour &&
        rooms == other.rooms &&
        description == other.description &&
        subject == other.subject &&
        exam == other.exam &&
        homework == other.homework &&
        teachers == other.teachers;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc($jc($jc($jc(0, fromHour.hashCode), toHour.hashCode), rooms.hashCode),
                        description.hashCode),
                    subject.hashCode),
                exam.hashCode),
            homework.hashCode),
        teachers.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('CalendarHour')
          ..add('fromHour', fromHour)
          ..add('toHour', toHour)
          ..add('rooms', rooms)
          ..add('description', description)
          ..add('subject', subject)
          ..add('exam', exam)
          ..add('homework', homework)
          ..add('teachers', teachers))
        .toString();
  }
}

class CalendarHourBuilder implements Builder<CalendarHour, CalendarHourBuilder> {
  _$CalendarHour _$v;

  int _fromHour;
  int get fromHour => _$this._fromHour;
  set fromHour(int fromHour) => _$this._fromHour = fromHour;

  int _toHour;
  int get toHour => _$this._toHour;
  set toHour(int toHour) => _$this._toHour = toHour;

  ListBuilder<String> _rooms;
  ListBuilder<String> get rooms => _$this._rooms ??= new ListBuilder<String>();
  set rooms(ListBuilder<String> rooms) => _$this._rooms = rooms;

  String _description;
  String get description => _$this._description;
  set description(String description) => _$this._description = description;

  String _subject;
  String get subject => _$this._subject;
  set subject(String subject) => _$this._subject = subject;

  String _exam;
  String get exam => _$this._exam;
  set exam(String exam) => _$this._exam = exam;

  String _homework;
  String get homework => _$this._homework;
  set homework(String homework) => _$this._homework = homework;

  ListBuilder<Teacher> _teachers;
  ListBuilder<Teacher> get teachers => _$this._teachers ??= new ListBuilder<Teacher>();
  set teachers(ListBuilder<Teacher> teachers) => _$this._teachers = teachers;

  CalendarHourBuilder() {
    CalendarHour._initializeBuilder(this);
  }

  CalendarHourBuilder get _$this {
    if (_$v != null) {
      _fromHour = _$v.fromHour;
      _toHour = _$v.toHour;
      _rooms = _$v.rooms?.toBuilder();
      _description = _$v.description;
      _subject = _$v.subject;
      _exam = _$v.exam;
      _homework = _$v.homework;
      _teachers = _$v.teachers?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CalendarHour other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$CalendarHour;
  }

  @override
  void update(void Function(CalendarHourBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$CalendarHour build() {
    _$CalendarHour _$result;
    try {
      _$result = _$v ??
          new _$CalendarHour._(
              fromHour: fromHour,
              toHour: toHour,
              rooms: rooms.build(),
              description: description,
              subject: subject,
              exam: exam,
              homework: homework,
              teachers: teachers.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'rooms';
        rooms.build();

        _$failedField = 'teachers';
        teachers.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError('CalendarHour', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$Teacher extends Teacher {
  @override
  final String firstName;
  @override
  final String lastName;

  factory _$Teacher([void Function(TeacherBuilder) updates]) =>
      (new TeacherBuilder()..update(updates)).build();

  _$Teacher._({this.firstName, this.lastName}) : super._() {
    if (firstName == null) {
      throw new BuiltValueNullFieldError('Teacher', 'firstName');
    }
    if (lastName == null) {
      throw new BuiltValueNullFieldError('Teacher', 'lastName');
    }
  }

  @override
  Teacher rebuild(void Function(TeacherBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  TeacherBuilder toBuilder() => new TeacherBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Teacher && firstName == other.firstName && lastName == other.lastName;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, firstName.hashCode), lastName.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Teacher')
          ..add('firstName', firstName)
          ..add('lastName', lastName))
        .toString();
  }
}

class TeacherBuilder implements Builder<Teacher, TeacherBuilder> {
  _$Teacher _$v;

  String _firstName;
  String get firstName => _$this._firstName;
  set firstName(String firstName) => _$this._firstName = firstName;

  String _lastName;
  String get lastName => _$this._lastName;
  set lastName(String lastName) => _$this._lastName = lastName;

  TeacherBuilder();

  TeacherBuilder get _$this {
    if (_$v != null) {
      _firstName = _$v.firstName;
      _lastName = _$v.lastName;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Teacher other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Teacher;
  }

  @override
  void update(void Function(TeacherBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Teacher build() {
    final _$result = _$v ?? new _$Teacher._(firstName: firstName, lastName: lastName);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
