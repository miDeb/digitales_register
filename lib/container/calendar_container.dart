import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../actions.dart';
import '../app_state.dart';
import '../ui/calendar.dart';

class CalendarContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CalendarViewModel>(
      builder: (BuildContext context, CalendarViewModel vm) {
        return Calendar(
          vm: vm,
        );
      },
      distinct: true,
      converter: (Store<AppState> store) {
        return CalendarViewModel(store);
      },
    );
  }
}

typedef void DayCallback(DateTime day);

class CalendarViewModel {
  final DayCallback dayCallback;

  CalendarViewModel(Store<AppState> store)
      : dayCallback = ((day) {
          store.dispatch(LoadCalendarAction(day));
        });
}
