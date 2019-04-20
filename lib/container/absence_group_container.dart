import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:redux/redux.dart';

import '../app_state.dart';
import '../data.dart';
import '../ui/absence.dart';

class AbsenceGroupContainer extends StatelessWidget {
  final int group;

  const AbsenceGroupContainer({
    Key key,
    @required this.group,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AbsencesViewModel>(
      builder: (BuildContext context, vm) {
        return AbsenceGroupWidget(vm: vm);
      },
      converter: (Store<AppState> store) {
        final absenceGroup = store.state.absenceState.absences[group];
        final first = absenceGroup.absences.last;
        final last = absenceGroup.absences.first;
        var fromTo = "";
        if (first.date == last.date) {
          fromTo += "${DateFormat("d.M.").format(first.date)}, ";
          if (first == last) {
            fromTo += "${first.hour}. h";
          } else {
            fromTo += "${first.hour}-${last.hour}. h";
          }
        } else {
          fromTo +=
              "${DateFormat("d.M.").format(first.date)} ${first.hour}. h - ${DateFormat("d.M.").format(last.date)} ${last.hour}. h ";
        }
        var duration = "";
        if (absenceGroup.hours != 0) {
          duration += "${absenceGroup.hours} Schulstunden";
        }
        if (absenceGroup.minutes != 0) {
          if (duration != "") duration += ", ";
          duration += "${absenceGroup.minutes} Minuten";
        }
        String justifiedString;
        switch (absenceGroup.justified) {
          case AbsenceJustified.justified:
            justifiedString =
                "${DateFormat("'Am' d.M.yy 'um' HH:mm:ss").format(absenceGroup.reasonTimestamp)} von ${absenceGroup.reasonSignature} entschuldigt";
            break;
          case AbsenceJustified.forSchool:
            justifiedString = "Im Auftrag der Schule (entschuldigt)";
            break;
          case AbsenceJustified.notJustified:
            justifiedString = "Nicht entschuldigt";
            break;
          default:
            justifiedString = "Noch nicht entschuldigt";
            break;
        }
        return AbsencesViewModel(fromTo, duration, justifiedString,
            absenceGroup.reason, absenceGroup.justified);
      },
    );
  }
}

class AbsencesViewModel {
  final String fromTo;
  final String duration;
  final String justifiedString;
  final String reason;
  final AbsenceJustified justified;

  AbsencesViewModel(this.fromTo, this.duration, this.justifiedString,
      this.reason, this.justified);
}
