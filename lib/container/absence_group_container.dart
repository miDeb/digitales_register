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

import 'package:dr/l10n/l10n.dart' as l10n;
import 'package:flutter/material.dart';
import 'package:flutter_built_redux/flutter_built_redux.dart';
import 'package:intl/intl.dart';

import '../actions/app_actions.dart';
import '../app_state.dart';
import '../data.dart';
import '../ui/absence.dart';

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
          fromTo += "${DateFormat.Md().format(first.date)}, ";
          if (first == last) {
            fromTo += l10n.lessonIndex(first.hour);
          } else {
            fromTo += l10n.lessonSpan(first.hour, last.hour);
          }
        } else {
          fromTo += l10n.absenceDuration(DateFormat.Md().format(first.date),
              first.hour, DateFormat.Md().format(last.date), last.hour);
        }
        var duration = "";
        if (absenceGroup.hours != 0) {
          duration += "${absenceGroup.hours} ${l10n.formatHours(absenceGroup.hours)}";
        }
        if (absenceGroup.minutes != 0) {
          if (duration != "") duration += ", ";
          duration += "${absenceGroup.minutes} ${l10n.formatMinutes(absenceGroup.minutes)}";
        }
        String justifiedString;
        switch (absenceGroup.justified) {
          case AbsenceJustified.justified:
            justifiedString = absenceGroup.reasonSignature != null &&
                    absenceGroup.reasonTimestamp != null
                ? l10n.absenceJustifiedBy(
                    DateFormat.yMd().format(absenceGroup.reasonTimestamp!),
                    DateFormat.Hm().format(absenceGroup.reasonTimestamp!),
                    absenceGroup.reasonSignature!,
                  )
                : l10n.absenceJustified();
            break;
          case AbsenceJustified.forSchool:
            justifiedString = l10n.absenceJustifiedBySchool();
            break;
          case AbsenceJustified.notJustified:
            justifiedString = l10n.absenceNotJustified();
            break;
          default:
            justifiedString = l10n.absenceNotYetJustified();
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
