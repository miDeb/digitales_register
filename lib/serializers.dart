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

import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';

import 'package:dr/app_state.dart';
import 'package:dr/data.dart';
import 'package:dr/utc_date_time.dart';

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

class DateTimeSerializer implements PrimitiveSerializer<UtcDateTime> {
  final bool structured = false;
  @override
  final Iterable<Type> types = BuiltList<Type>(<Type>[UtcDateTime]);
  @override
  final String wireName = 'UtcDateTime';

  @override
  Object serialize(Serializers serializers, UtcDateTime dateTime,
      {FullType specifiedType = FullType.unspecified}) {
    return dateTime.toIso8601String();
  }

  @override
  UtcDateTime deserialize(Serializers serializers, Object serialized,
      {FullType specifiedType = FullType.unspecified}) {
    return UtcDateTime.parse(serialized as String);
  }
}
