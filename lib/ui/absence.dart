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
import 'package:intl/intl.dart';

import '../container/absence_group_container.dart';
import '../data.dart';

class AbsenceGroupWidget extends StatelessWidget {
  final AbsencesViewModel vm;

  const AbsenceGroupWidget({Key? key, required this.vm}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final divider = Row(
      children: const [
        Spacer(),
        Flexible(
          flex: 48,
          child: Divider(
            height: 8,
          ),
        ),
        Spacer(),
      ],
    );

    return Card(
      shape: RoundedRectangleBorder(
        side: vm.justified == AbsenceJustified.notYetJustified ||
                vm.justified == AbsenceJustified.notJustified
            ? const BorderSide(color: Colors.red)
            : const BorderSide(color: Colors.green, width: 0),
        borderRadius: BorderRadius.circular(16),
      ),
      color: Colors.transparent,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            if (vm.reason != null) ...[
              Text(vm.reason!),
              divider,
            ],
            if (vm.note != null) ...[
              Text(vm.note!),
              divider,
            ],
            Text(
              vm.fromTo,
              style: Theme.of(context).textTheme.subtitle1,
            ),
            Text(
              vm.duration,
              style: Theme.of(context).textTheme.bodyText2,
            ),
            divider,
            Text(
              vm.justifiedString,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class FutureAbsenceWidget extends StatelessWidget {
  final FutureAbsence absence;
  const FutureAbsenceWidget({
    Key? key,
    required this.absence,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var fromTo = "";
    if (absence.startDate == absence.endDate) {
      fromTo +=
          "${DateFormat("EE d.M.yyyy", "de").format(absence.startDate)}, ";
      if (absence.startHour == absence.endHour) {
        fromTo += "${absence.startHour}. h";
      } else {
        fromTo += "${absence.startHour}. - ${absence.endHour}. h";
      }
    } else {
      fromTo +=
          "${DateFormat("EE d.M.yyyy", "de").format(absence.startDate)} ${absence.startHour}. h - ${DateFormat("EE d.M.yyyy", "de").format(absence.endDate)} ${absence.endHour}. h ";
    }

    String justifiedString;
    switch (absence.justified) {
      case AbsenceJustified.justified:
        justifiedString = "Entschuldigt";
        break;
      case AbsenceJustified.forSchool:
        justifiedString = "Em Auftrag der Schule (entschuldigt)";
        break;
      case AbsenceJustified.notJustified:
        justifiedString = "Nicht entschuldigt";
        break;
      default:
        justifiedString = "Noch nicht entschuldigt";
        break;
    }

    final divider = Row(
      children: const [
        Spacer(),
        Flexible(
          flex: 48,
          child: Divider(
            height: 8,
          ),
        ),
        Spacer(),
      ],
    );

    return Card(
      shape: RoundedRectangleBorder(
        side: absence.justified == AbsenceJustified.notYetJustified ||
                absence.justified == AbsenceJustified.notJustified
            ? const BorderSide(color: Colors.red)
            : const BorderSide(color: Colors.green, width: 0),
        borderRadius: BorderRadius.circular(16),
      ),
      color: Colors.transparent,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            if (absence.note != null) ...[
              Text(absence.note!),
              divider,
            ],
            if (absence.reason != null) ...[
              Text(absence.reason!),
              divider,
            ],
            Text(
              fromTo,
              style: Theme.of(context).textTheme.subtitle1,
            ),
            divider,
            Text(
              "${DateFormat("EE d.M.yyyy 'um' HH:mm", "de").format(absence.reasonTimestamp!)} als „${absence.reasonSignature}“ eingetragen",
            ),
            divider,
            Text(justifiedString),
          ],
        ),
      ),
    );
  }
}
