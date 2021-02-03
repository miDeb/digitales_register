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

extension MapEntryToTuple<K, V> on MapEntry<K, V> {
  Tuple2<K, V> toTuple() {
    return Tuple2(key, value);
  }
}

NumberFormat gradeAverageFormat = NumberFormat("#0.##", "de");

class ParseException implements Exception {
  final String payload;
  final dynamic parent;
  final StackTrace trace;

  ParseException(this.payload, this.parent, this.trace);

  @override
  String toString() {
    return "ParseException\nwhile parsing:\n\n$payload\n\nThe following was thrown:\n\n$parent\n\n$trace";
  }
}

O tryParse<O, I>(I input, O Function(I input) parse) {
  try {
    return parse(input);
  } catch (e, trace) {
    if (e is ParseException) {
      // let parseExceptions bubble up, and do not nest them
      rethrow;
    }
    throw ParseException(input.toString(), e, trace);
  }
}
