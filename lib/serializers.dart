import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';

import 'app_state.dart';
import 'data.dart';

part 'serializers.g.dart';

@SerializersFor(const [
  GradesState,
  NotificationState,
  DayState,
  AbsenceState,
  CalendarState,
  SettingsState,
])
final Serializers serializers = (_$serializers.toBuilder()
      ..add(SubjectSerializer())
      ..add(NotificationSerializer())
      ..add(DateTimeSerializer()))
    .build();

class SubjectSerializer implements PrimitiveSerializer<SingleSemesterSubject> {
  @override
  final Iterable<Type> types = new BuiltList<Type>([SingleSemesterSubject]);
  @override
  final String wireName = 'Subject';

  @override
  Object serialize(Serializers serializers, SingleSemesterSubject subject,
      {FullType specifiedType = FullType.unspecified}) {
    return subject.toJson();
  }

  @override
  SingleSemesterSubject deserialize(Serializers serializers, serialized,
      {FullType specifiedType = FullType.unspecified}) {
    return SingleSemesterSubject.parse(serialized);
  }
}

class NotificationSerializer implements PrimitiveSerializer<Notification> {
  @override
  final Iterable<Type> types = new BuiltList<Type>([Notification]);
  @override
  final String wireName = 'Notification';

  @override
  Object serialize(Serializers serializers, Notification notification,
      {FullType specifiedType = FullType.unspecified}) {
    return notification.toJson();
  }

  @override
  Notification deserialize(Serializers serializers, serialized,
      {FullType specifiedType = FullType.unspecified}) {
    return Notification.parse(serialized);
  }
}

class DateTimeSerializer implements PrimitiveSerializer<DateTime> {
  final bool structured = false;
  @override
  final Iterable<Type> types = new BuiltList<Type>([DateTime]);
  @override
  final String wireName = 'DateTime';

  @override
  Object serialize(Serializers serializers, DateTime dateTime,
      {FullType specifiedType = FullType.unspecified}) {
    return dateTime.toIso8601String();
  }

  @override
  DateTime deserialize(Serializers serializers, Object serialized,
      {FullType specifiedType = FullType.unspecified}) {
    return DateTime.parse(serialized as String);
  }
}
