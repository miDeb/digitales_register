import 'package:built_collection/built_collection.dart';
import 'package:built_redux/built_redux.dart';

import '../actions/absences_actions.dart';
import '../app_state.dart';
import '../data.dart';
import '../util.dart';

final absencesReducerBuilder = NestedReducerBuilder<AppState, AppStateBuilder,
    AbsencesState, AbsencesStateBuilder>(
  (s) => s.absencesState,
  (b) => b.absencesState,
)..add(AbsencesActionsNames.loaded, _loaded);

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
    ..percentage = rawStats["percentage"].toString();
  final absences = (json["absences"] as List).map((g) {
    return AbsenceGroup(
      (b) => b
        ..justified = AbsenceJustified.fromInt(getInt(g["justified"])!)
        ..reasonSignature = getString(g["reason_signature"])
        ..reasonTimestamp = g["reason_timestamp"] is String
            ? DateTime.tryParse(g["reason_timestamp"] as String)
            : null
        ..reason = getString(g["reason"])
        ..absences = ListBuilder(
          (g["group"] as List).map(
            (a) {
              return Absence(
                (b) => b
                  ..minutes = getInt(a["minutes"])
                  ..date = DateTime.parse(getString(a["date"])!)
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
