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

import 'package:dr/l10n/l10n.dart';
import 'package:dr/ui/last_fetched_overlay.dart';
import 'package:flutter/material.dart';
import 'package:responsive_scaffold/responsive_scaffold.dart';

import '../app_state.dart';
import '../container/absence_group_container.dart';
import '../data.dart';
import 'no_internet.dart';

class AbsencesPage extends StatelessWidget {
  final AbsencesState state;
  final bool noInternet;

  const AbsencesPage({Key? key, required this.state, required this.noInternet})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResponsiveAppBar(
        title: Text(absencesTitle()),
      ),
      body: LastFetchedOverlay(
        lastFetched: state.lastFetched,
        noInternet: noInternet,
        child: AbsencesBody(
          state: state,
          noInternet: noInternet,
        ),
      ),
    );
  }
}

class AbsencesBody extends StatelessWidget {
  final AbsencesState state;
  final bool noInternet;

  const AbsencesBody({Key? key, required this.state, required this.noInternet})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return state.statistic != null
        ? state.absences.isEmpty
            ? Center(
                child: Text(
                  noAbsencesYet(),
                  style: Theme.of(context).textTheme.headline4,
                  textAlign: TextAlign.center,
                ),
              )
            : ListView(children: <Widget>[
                AbsencesStatisticWidget(
                  stat: state.statistic!,
                ),
                ...List.generate(
                  state.absences.length,
                  (n) => AbsenceGroupContainer(
                    group: state.absences.length - n - 1,
                  ),
                ),
              ])
        : noInternet
            ? const NoInternet()
            : const Center(
                child: CircularProgressIndicator(),
              );
  }
}

class AbsencesStatisticWidget extends StatelessWidget {
  final AbsenceStatistic stat;

  const AbsencesStatisticWidget({Key? key, required this.stat})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(absencesStatistic()),
      children: <Widget>[
        if (stat.counter != null)
          ListTile(
            title: Text(absencesTitle()),
            trailing: Text(stat.counter.toString()),
          ),
        if (stat.counterForSchool != null)
          ListTile(
            title: Text(absencesForSchool()),
            trailing: Text(stat.counterForSchool.toString()),
          ),
        if (stat.delayed != null)
          ListTile(
            title: Text(absencesDelays()),
            trailing: Text(stat.delayed.toString()),
          ),
        if (stat.justified != null)
          ListTile(
            title: Text(absencesJustified()),
            trailing: Text(stat.justified.toString()),
          ),
        if (stat.notJustified != null)
          ListTile(
            title: Text(absencesJustified()),
            trailing: Text(stat.notJustified.toString()),
          ),
        if (stat.percentage != null)
          ListTile(
            title: Text(absencesPercentageTitle()),
            trailing: Text("${stat.percentage} %"),
          ),
      ],
    );
  }
}
