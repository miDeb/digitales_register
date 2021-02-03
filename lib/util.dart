import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tuple/tuple.dart';

Widget maybeWrap(Widget widget, Widget Function(Widget w) wrapWidget,
    {@required bool wrap}) {
  if (wrap) {
    return wrapWidget(widget);
  } else {
    return widget;
  }
}

extension StringUtils on String {
  bool get isNullOrEmpty {
    if (this == null) return true;
    return isEmpty;
  }
}

DateTime toMonday(DateTime date) {
  final s = date.weekday >= 6
      ? date.add(Duration(days: 8 - date.weekday))
      : date.subtract(
          Duration(days: date.weekday - 1),
        );
  return DateTime.utc(s.year, s.month, s.day);
}

DateTime get now => mockNow ?? DateTime.now();
DateTime mockNow;

String stringifyMaybeJson(dynamic param) {
  final encoder = JsonEncoder.withIndent("  ", (object) => object.toString());
  return encoder.convert(param);
}

extension MapEntryToTuple<K, V> on MapEntry<K, V> {
  Tuple2<K, V> toTuple() {
    return Tuple2(key, value);
  }
}

NumberFormat gradeAverageFormat = NumberFormat("#0.##", "de");

class ParseException implements Exception {
  final String payload;
  final String parent;
  final StackTrace trace;

  /// If false, the ParseException will be rethrown in [tryParse], instead it
  /// will be wrapped in another ParseException to provide more context.
  final bool hasEnoughContext;

  ParseException(
    this.payload,
    this.parent,
    this.trace, {
    this.hasEnoughContext,
  });

  @override
  String toString() {
    final indentedParent = StringBuffer();
    for (final line in parent.split("\n")) {
      indentedParent.write(">    ");
      indentedParent.writeln(line);
    }

    return "ParseException\nwhile parsing:\n\n$payload\n\nThe following was thrown:\n\n$indentedParent\n\n$trace";
  }
}

O tryParse<O, I>(
  I input,
  O Function(I input) parse, {
  bool hasEnoughContext = true,
}) {
  try {
    return parse(input);
  } catch (e, trace) {
    if (e is ParseException && e.hasEnoughContext) {
      // let parseExceptions bubble up, do not nest them
      rethrow;
    }
    throw ParseException(
      stringifyMaybeJson(input),
      e.toString(),
      trace,
      hasEnoughContext: hasEnoughContext,
    );
  }
}

T _unexpectedType<T>(dynamic value) {
  assert(T != dynamic);
  assert(value is! T);
  // will construct a nice error message about this failing cast
  final result =
      tryParse(value, (input) => input as T, hasEnoughContext: false);
  // this should not happen, as the above cast will fail.
  assert(false);
  return result;
}

String getString(dynamic value) {
  if (value == null) return null;
  if (value is! String) {
    log("getString: expected String but got ${value.runtimeType}");
  }
  return value.toString();
}

bool getBool(dynamic value) {
  if (value == null) return null;
  if (value is bool) {
    return value;
  }
  if (value is int) {
    return value != 0;
  }
  return _unexpectedType(value);
}

int getInt(dynamic value) {
  if (value == null) return null;
  if (value is int) {
    return value;
  }
  if (value is String) {
    return tryParse(value, int.parse, hasEnoughContext: false);
  }
  return _unexpectedType(value);
}
