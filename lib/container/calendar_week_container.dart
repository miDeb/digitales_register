import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:quiver_hashcode/hashcode.dart';
import 'package:redux/redux.dart';
import 'package:collection/collection.dart';

import '../app_state.dart';
import '../data.dart';
import '../ui/calendar_week.dart';

class CalendarWeekContainer extends StatelessWidget {
  final DateTime monday;

  const CalendarWeekContainer({Key key, this.monday}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StoreConnector(
      builder: (BuildContext context, vm) {
        return CalendarWeek(vm: vm, key: key);
      },
      converter: (Store<AppState> store) {
        return CalendarWeekViewModel(store, monday);
      },
      distinct: true,
    );
  }
}

typedef void DayCallback(DateTime day);

class CalendarWeekViewModel {
  final List<CalendarDay> days;
  final Map<String, String> subjectNicks;

  @override
  bool operator ==(other) {
    return other is CalendarWeekViewModel &&
        DeepCollectionEquality().equals(this.days, other.days) &&
        DeepCollectionEquality().equals(this.subjectNicks, other.subjectNicks);
  }

  int get hashCode => hash2(days, subjectNicks);

  CalendarWeekViewModel(Store<AppState> store, DateTime monday)
      : days = store.state.calendarState.daysForWeek(monday),
        subjectNicks = store.state.settingsState.subjectNicks.toMap();
}
