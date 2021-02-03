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
    AbsencesState state, Action<Object> action, AbsencesStateBuilder builder) {
  return builder.replace(tryParse(action.payload, _parseAbsences));
}

AbsencesState _parseAbsences(json) {
  final rawStats = json["statistics"];
  final stats = AbsenceStatisticBuilder()
    ..counter = rawStats["counter"] as int
    ..counterForSchool = rawStats["counterForSchool"] as int
    ..delayed = rawStats["delayed"] as int
    ..justified = rawStats["justified"] as int
    ..notJustified = rawStats["notJustified"] as int
    ..percentage = rawStats["percentage"].toString();
  final absences = (json["absences"] as List).map((g) {
    return AbsenceGroup(
      (b) => b
        ..justified = AbsenceJustified.fromInt(g["justified"] as int)
        ..reasonSignature = g["reason_signature"] as String
        ..reasonTimestamp = g["reason_timestamp"] is String
            ? DateTime.tryParse(g["reason_timestamp"] as String)
            : null
        ..reason = g["reason"] as String
        ..absences = ListBuilder(
          (g["group"] as List).map(
            (a) {
              return Absence(
                (b) => b
                  ..minutes = a["minutes"] as int
                  ..date = DateTime.parse(a["date"] as String)
                  ..hour = a["hour"] as int
                  ..minutesCameTooLate = a["minutes_begin"] as int
                  ..minutesLeftTooEarly = a["minutes_end"] as int,
              );
            },
          ),
        )
        ..minutes = b.absences.build().fold(0, (min, a) {
          if (a.minutes != 50) {
            min += a.minutesCameTooLate + a.minutesLeftTooEarly;
          }
          return min;
        })
        ..hours = b.absences.build().fold(0, (h, a) {
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
