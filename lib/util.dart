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

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dr/utc_date_time.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tuple/tuple.dart';

late final PackageInfo packageInfo;

String get appVersion {
  if (Platform.environment.containsKey('FLUTTER_TEST')) {
    return "1.0";
  }
  return packageInfo.version;
}

Widget maybeWrap(Widget widget, Widget Function(Widget w) wrapWidget,
    {required bool wrap}) {
  if (wrap) {
    return wrapWidget(widget);
  } else {
    return widget;
  }
}

extension ListIntersperse<T> on List<List<T>> {
  List<T> intersperse(T element) {
    final result = <T>[];
    for (int i = 0; i < length; i++) {
      result.addAll(this[i]);
      if (i < length - 1) {
        result.add(element);
      }
    }
    return result;
  }
}

extension StringUtils on String? {
  bool get isNullOrEmpty {
    if (this == null) return true;
    return this!.isEmpty;
  }
}

UtcDateTime toMonday(UtcDateTime date) {
  final s = date.weekday >= 6
      ? date.add(Duration(days: 8 - date.weekday))
      : date.subtract(
          Duration(days: date.weekday - 1),
        );
  return UtcDateTime(s.year, s.month, s.day);
}

UtcDateTime get now => mockNow ?? UtcDateTime.now();
@visibleForTesting
UtcDateTime? mockNow;

String stringifyMaybeJson(dynamic param) {
  final encoder =
      JsonEncoder.withIndent("  ", (dynamic object) => object.toString());
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
    required this.hasEnoughContext,
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

Never _unexpectedType<T>(dynamic value) {
  assert(T != dynamic);
  assert(value is! T);
  // will construct a nice error message about this failing cast
  tryParse<Never, dynamic>(
    value,
    (dynamic input) {
      input as T?;
      throw Error();
    },
    hasEnoughContext: false,
  );
}

String? getString(dynamic value) {
  if (value == null) return null;
  if (value is! String) {
    log("getString: expected String but got ${value.runtimeType}");
  }
  return value.toString();
}

bool? getBool(dynamic value) {
  if (value == null) return null;
  if (value is bool) {
    return value;
  }
  if (value is int) {
    return value != 0;
  }
  return _unexpectedType<bool>(value);
}

int? getInt(dynamic value) {
  if (value == null) return null;
  if (value is int) {
    return value;
  }
  if (value is String) {
    return int.tryParse(value);
  }
  return _unexpectedType<int>(value);
}

Map? getMap(dynamic value) {
  if (value == null) return null;
  dynamic decoded = value;
  if (value is String) {
    decoded = tryParse<dynamic, String>(value, json.decode);
  }
  return _checkIsMap(decoded);
}

List? getList(dynamic value) {
  if (value == null) return null;
  dynamic decoded = value;
  if (value is String) {
    decoded = tryParse<dynamic, String>(value, json.decode);
  }
  return _checkIsList(decoded);
}

Map? _checkIsMap(dynamic json) {
  if (json is! Map) {
    _unexpectedType<Map>(json);
  } else {
    return json;
  }
}

List? _checkIsList(dynamic json) {
  if (json is! List) {
    _unexpectedType<List>(json);
  } else {
    return json;
  }
}

String fixupUrl(String enteredUrl) {
  var url = enteredUrl;
  if (Uri.parse(url).scheme.isEmpty) {
    // add https:// if there is no uri scheme
    url = "https://$url";
  }
  const defaultUrlPath = "v2/login";
  if (url.endsWith(defaultUrlPath)) {
    // /v2/login is the default path the browser is redirected to when loading
    // the web app. Users might just copy-paste that url, so let's strip it.
    url = url.substring(0, url.length - defaultUrlPath.length);
  }
  return url;
}

Future<bool> cannotConnectTo(String url) async {
  var noInternet = false;
  try {
    final result = await http.get(Uri.parse(url));
    noInternet = result.statusCode != 200;
  } catch (e) {
    noInternet = true;
  }
  return noInternet;
}
