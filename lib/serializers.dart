import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';

import 'app_state.dart';
import 'data.dart';

part 'serializers.g.dart';

@SerializersFor([
  AppState,
  // needed due to https://github.com/google/built_value.dart/issues/124
  GradeAll,
  GradeDetail,
  Observation,
  //
])
final Serializers serializers = (_$serializers.toBuilder()
      ..add(DateTimeSerializer())
      // needed due to https://github.com/google/built_value.dart/issues/124
      ..addBuilderFactory(const FullType(BuiltList, [FullType(GradeAll)]),
          () => ListBuilder<GradeAll>())
      ..addBuilderFactory(const FullType(BuiltList, [FullType(GradeDetail)]),
          () => ListBuilder<GradeDetail>())
      ..addBuilderFactory(const FullType(BuiltList, [FullType(Observation)]),
          () => ListBuilder<Observation>()))
    //
    .build();

class DateTimeSerializer implements PrimitiveSerializer<DateTime> {
  final bool structured = false;
  @override
  final Iterable<Type> types = BuiltList<Type>([DateTime]);
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
