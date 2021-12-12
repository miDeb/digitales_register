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

import 'package:flutter/material.dart';
import 'package:flutter_built_redux/flutter_built_redux.dart';
import 'package:intl/intl.dart';

import '../actions/app_actions.dart';
import '../app_state.dart';
import '../data.dart';
import '../ui/absence.dart';

// TODO: localize

class AbsenceGroupContainer extends StatelessWidget {
  final int group;

  const AbsenceGroupContainer({
    Key? key,
    required this.group,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StoreConnection<AppState, AppActions, AbsencesViewModel>(
      builder: (context, vm, actions) {
        return AbsenceGroupWidget(vm: vm);
      },
      connect: (state) {
        final absenceGroup = state.absencesState.absences[group];
        final first = absenceGroup.absences.last; //<--- flip is intentional
        final last = absenceGroup.absences.first; //<---
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
            justifiedString = absenceGroup.reasonSignature != null &&
                    absenceGroup.reasonTimestamp != null
                ? "${DateFormat("'Am' d.M.yy 'um' HH:mm:ss").format(absenceGroup.reasonTimestamp!)} von ${absenceGroup.reasonSignature} entschuldigt"
                : "entschuldigt";
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
  final String? reason;
  final AbsenceJustified justified;

  AbsencesViewModel(this.fromTo, this.duration, this.justifiedString,
      this.reason, this.justified);
}
