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
import 'package:built_redux/built_redux.dart';

import '../actions/absences_actions.dart';
import '../app_state.dart';
import '../data.dart';
import '../utc_date_time.dart';
import '../util.dart';

final absencesReducerBuilder = NestedReducerBuilder<AppState, AppStateBuilder,
    AbsencesState, AbsencesStateBuilder>(
  (s) => s.absencesState,
  (b) => b.absencesState,
)..add<dynamic>(AbsencesActionsNames.loaded, _loaded);

void _loaded(
    AbsencesState state, Action<dynamic> action, AbsencesStateBuilder builder) {
  return builder.replace(tryParse(getMap(action.payload)!, _parseAbsences));
}

AbsencesState _parseAbsences(Map json) {
  final rawStats = getMap(json["statistics"])!;
  final stats = AbsenceStatisticBuilder()
    ..counter = getInt(rawStats["counter"])
    ..counterForSchool = getInt(rawStats["counterForSchool"])
    ..delayed = getInt(rawStats["delayed"])
    ..justified = getInt(rawStats["justified"])
    ..notJustified = getInt(rawStats["notJustified"])
    ..percentage = rawStats["percentage"]?.toString().isNotEmpty == true
        ? rawStats["percentage"].toString()
        : null;
  final absences = (json["absences"] as List).map((dynamic g) {
    return AbsenceGroup(
      (b) => b
        ..justified = AbsenceJustified.fromInt(getInt(g["justified"])!)
        ..reasonSignature = getString(g["reason_signature"])
        ..reasonTimestamp = g["reason_timestamp"] is String
            ? UtcDateTime.tryParse(g["reason_timestamp"] as String)
            : null
        ..reason = getString(g["reason"])
        ..absences = ListBuilder(
          (g["group"] as List).map<Absence>(
            (dynamic a) {
              return Absence(
                (b) => b
                  ..minutes = getInt(a["minutes"])
                  ..date = UtcDateTime.parse(getString(a["date"])!)
                  ..hour = getInt(a["hour"])
                  ..minutesCameTooLate = getInt(a["minutes_begin"])
                  ..minutesLeftTooEarly = getInt(a["minutes_end"]),
              );
            },
          ),
        )
        ..minutes = b.absences.build().fold<int>(0, (min, a) {
          if (a.minutes != 50) {
            min += a.minutesCameTooLate + a.minutesLeftTooEarly;
          }
          return min;
        })
        ..hours = b.absences.build().fold<int>(0, (h, a) {
          if (a.minutes == 50) {
            h++;
          }
          return h;
        }),
    );
  });
  return AbsencesState(
    (b) => b
      ..statistic = stats
      ..absences = ListBuilder(absences),
  );
}
