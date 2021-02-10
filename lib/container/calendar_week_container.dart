import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:flutter/material.dart' hide Builder;
import 'package:flutter_built_redux/flutter_built_redux.dart';

import '../actions/app_actions.dart';
import '../app_state.dart';
import '../data.dart';
import '../ui/calendar_week.dart';

part 'calendar_week_container.g.dart';

class CalendarWeekContainer extends StatelessWidget {
  final DateTime monday;

  const CalendarWeekContainer({Key? key, required this.monday})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StoreConnection<AppState, AppActions, CalendarWeekViewModel>(
      builder: (context, vm, actions) {
        return CalendarWeek(vm: vm, key: key);
      },
      connect: (state) {
        return CalendarWeekViewModel.fromStateAndWeek(state, monday);
      },
    );
  }
}

typedef DayCallback = void Function(DateTime day);

abstract class CalendarWeekViewModel
    implements Built<CalendarWeekViewModel, CalendarWeekViewModelBuilder> {
  BuiltList<CalendarDay> get days;
  BuiltMap<String, String> get subjectNicks;
  bool get noInternet;

  factory CalendarWeekViewModel(
          [void Function(CalendarWeekViewModelBuilder)? updates]) =
      _$CalendarWeekViewModel;
  CalendarWeekViewModel._();

  factory CalendarWeekViewModel.fromStateAndWeek(
      AppState state, DateTime monday) {
    return CalendarWeekViewModel(
      (b) => b
        ..days = ListBuilder(state.calendarState.daysForWeek(monday))
        // converting all keys (subject names) to lower case to make accessing cheaper
        ..subjectNicks = MapBuilder(
          state.settingsState!.subjectNicks.toMap().map(
                (key, value) => MapEntry(
                  key.toLowerCase(),
                  value,
                ),
              ),
        )
        ..noInternet = state.noInternet,
    );
  }
}
