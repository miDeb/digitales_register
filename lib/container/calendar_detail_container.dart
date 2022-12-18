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

import 'package:built_value/built_value.dart';
import 'package:collection/collection.dart';
import 'package:dr/actions/app_actions.dart';
import 'package:dr/app_state.dart';
import 'package:dr/data.dart';
import 'package:dr/ui/calendar_detail.dart';
import 'package:dr/utc_date_time.dart';
import 'package:dr/util.dart';
import 'package:flutter/material.dart' hide Builder;
import 'package:flutter_built_redux/flutter_built_redux.dart';

part 'calendar_detail_container.g.dart';

class CalendarDetailContainer extends StatelessWidget {
  final bool isSidebar;
  final bool show;
  const CalendarDetailContainer({
    super.key,
    required this.isSidebar,
    required this.show,
  });

  @override
  Widget build(BuildContext context) {
    return StoreConnection<AppState, AppActions, CalendarDetailVM>(
      builder: (context, state, actions) => CalendarDetailPage(
        selectedDay: state.selectedDay,
        selectedHour: state.selectedHour,
        isSidebar: isSidebar,
        show: show,
      ),
      connect: (state) {
        final selection = state.calendarState.selection;
        return CalendarDetailVM(
          selectedDay: selection?.date,
          selectedHour: selection?.hour,
        );
      },
    );
  }
}

class CalendarDetailVM {
  final UtcDateTime? selectedDay;
  final int? selectedHour;

  CalendarDetailVM({
    required this.selectedDay,
    required this.selectedHour,
  });
}

class CalendarDetailItemContainer extends StatelessWidget {
  final UtcDateTime date;
  final bool isSidebar;
  const CalendarDetailItemContainer({
    super.key,
    required this.date,
    required this.isSidebar,
  });

  @override
  Widget build(BuildContext context) {
    return StoreConnection<AppState, AppActions, CalendarDetailItemVM>(
      builder: (context, state, actions) => CalendarDetailWrapper(
        date: date,
        day: state.day,
        targetHour: state.hour,
        noInternet: state.noInternet,
        loading: state.loading,
        isSidebar: isSidebar,
      ),
      connect: (state) {
        final day = state.calendarState.days[date];
        final hourIndex = state.calendarState.selection?.date == date
            ? state.calendarState.selection?.hour
            : null;

        final hour = day != null && hourIndex != null
            ? day.hours.firstWhereOrNull(
                (h) => h.fromHour <= hourIndex && h.toHour >= hourIndex)
            : null;
        final loading = state.calendarState.daysForWeek(toMonday(date)).isEmpty;
        return CalendarDetailItemVM(
          (b) => b
            ..day = day?.toBuilder()
            ..hour = hour?.toBuilder()
            ..noInternet = state.noInternet
            ..loading = loading,
        );
      },
    );
  }
}

abstract class CalendarDetailItemVM
    implements Built<CalendarDetailItemVM, CalendarDetailItemVMBuilder> {
  CalendarDay? get day;
  CalendarHour? get hour;
  bool get noInternet;
  bool get loading;

  factory CalendarDetailItemVM(
          [void Function(CalendarDetailItemVMBuilder)? updates]) =
      _$CalendarDetailItemVM;
  CalendarDetailItemVM._();
}
