import 'package:flutter/material.dart';

Widget maybeWrap(Widget widget, bool wrap, Widget wrapWidget(Widget w)) {
  if (wrap)
    return wrapWidget(widget);
  else
    return widget;
}

bool isNullOrEmpty(String s) {
  if (s == null) return true;
  s = s.trim();
  if (s == "") return true;
  return false;
}

DateTime toMonday(DateTime date) {
  final s = date.weekday >= 6
      ? date.add(Duration(days: 8 - date.weekday))
      : date.subtract(
          Duration(days: date.weekday - 1),
        );
  return DateTime.utc(s.year, s.month, s.day);
}
