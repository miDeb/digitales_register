import 'package:flutter/material.dart';

import '../app_state.dart';
import '../container/absence_group_container.dart';
import '../data.dart';
import 'no_internet.dart';

class AbsencesPage extends StatelessWidget {
  final AbsencesState state;
  final bool noInternet;

  const AbsencesPage({Key key, @required this.state, this.noInternet})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Absenzen"),
      ),
      body: AbsencesBody(
        state: state,
        noInternet: noInternet,
      ),
    );
  }
}

class AbsencesBody extends StatelessWidget {
  final AbsencesState state;
  final bool noInternet;

  const AbsencesBody({Key key, @required this.state, this.noInternet})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return state != null
        ? state.absences.isEmpty
            ? Center(
                child: Text(
                  "Noch keine Absenzen",
                  style: Theme.of(context).textTheme.display1,
                ),
              )
            : ListView(children: <Widget>[
                AbsencesStatisticWidget(
                  stat: state.statistic,
                ),
                ...List.generate(
                  state.absences.length,
                  (n) => AbsenceGroupContainer(
                    group: state.absences.length - n - 1,
                  ),
                ),
              ])
        : noInternet
            ? NoInternet()
            : Center(
                child: CircularProgressIndicator(),
              );
  }
}

class AbsencesStatisticWidget extends StatelessWidget {
  final AbsenceStatistic stat;

  const AbsencesStatisticWidget({Key key, @required this.stat})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text("Statistik"),
      children: <Widget>[
        ListTile(
          title: Text("Absenzen"),
          trailing: Text(stat.counter.toString()),
        ),
        ListTile(
          title: Text("Absenzen im Auftrag der Schule"),
          trailing: Text(stat.counterForSchool.toString()),
        ),
        ListTile(
          title: Text("Verspätungen"),
          trailing: Text(stat.delayed.toString()),
        ),
        ListTile(
          title: Text("Entschuldigte Absenzen"),
          trailing: Text(stat.justified.toString()),
        ),
        ListTile(
          title: Text("Nicht entschuldigte Absenzen"),
          trailing: Text(stat.notJustified.toString()),
        ),
        ListTile(
          title: Text("Abwesenheit"),
          trailing: Text(stat.percentage + " %"),
        ),
      ],
    );
  }
}
