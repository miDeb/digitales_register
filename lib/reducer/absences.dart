import 'package:built_collection/built_collection.dart';
import 'package:built_redux/built_redux.dart';

import '../actions/absences_actions.dart';
import '../app_state.dart';
import '../data.dart';

final absencesReducerBuilder =
    NestedReducerBuilder<AppState, AppStateBuilder, AbsencesState, AbsencesStateBuilder>(
  (s) => s.absencesState,
  (b) => b.absencesState,
)..add(AbsencesActionsNames.loaded, _loaded);

void _loaded(AbsencesState state, Action<Object> action, AbsencesStateBuilder builder) {
  return builder.replace(parseAbsences(action.payload));
}

AbsencesState parseAbsences(json) {
  final rawStats = json["statistics"];
  final stats = AbsenceStatisticBuilder()
    ..counter = rawStats["counter"]
    ..counterForSchool = rawStats["counterForSchool"]
    ..delayed = rawStats["delayed"]
    ..justified = rawStats["justified"]
    ..notJustified = rawStats["notJustified"]
    ..percentage = rawStats["percentage"].toString();
  final absences = (json["absences"] as List).map((g) {
    return AbsenceGroup(
      (b) => b
        ..justified = AbsenceJustified.fromInt(g["justified"])
        ..reasonSignature = g["reason_signature"]
        ..reasonTimestamp =
            g["reason_timestamp"] is String ? DateTime.tryParse(g["reason_timestamp"]) : null
        ..reason = g["reason"]
        ..absences = ListBuilder(
          (g["group"] as List).map(
            (a) {
              return Absence(
                (b) => b
                  ..minutes = a["minutes"]
                  ..date = DateTime.parse(a["date"])
                  ..hour = a["hour"]
                  ..minutesCameTooLate = a["minutes_begin"]
                  ..minutesLeftTooEarly = a["minutes_end"],
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
