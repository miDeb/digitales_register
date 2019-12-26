import 'package:flutter/material.dart';

import '../app_state.dart';
import '../container/grades_chart_container.dart';
import '../container/grades_page_container.dart';
import '../container/sorted_grades_container.dart';
import '../util.dart';
import 'no_internet.dart';

class GradesPage extends StatelessWidget {
  final GradesPageViewModel vm;
  final ValueChanged<Semester> changeSemester;

  const GradesPage({Key key, this.vm, this.changeSemester}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Noten"),
        actions: vm.loading
            ? null
            : <Widget>[
                Theme(
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<Semester>(
                      value: vm.showSemester,
                      items: Semester.values
                          .map(
                            (s) => DropdownMenuItem(
                              child: Text(
                                s.name,
                                style:
                                    (Theme.of(context).appBarTheme.textTheme ??
                                            Theme.of(context).primaryTextTheme)
                                        .body1,
                              ),
                              value: s,
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (vm.showSemester != value) changeSemester(value);
                      },
                    ),
                  ),
                  data: ThemeData.dark(),
                ),
              ],
      ),
      body: !vm.hasData && vm.noInternet
          ? NoInternet()
          : vm.loading && !vm.hasData
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : maybeWrap(
                  ListView(
                    children: <Widget>[
                      if (vm.showGradesDiagram)
                        SizedBox(
                          child: GradesChartContainer(isFullscreen: false),
                          height: 150,
                          width: 250,
                        ),
                      if (vm.showAllSubjectsAverage) ...[
                        ListTile(
                          title: Text("Ø aller Fächer"),
                          trailing: Text(vm.allSubjectsAverage),
                        ),
                        Divider(
                          height: 0,
                        ),
                      ],
                      SortedGradesContainer(),
                    ],
                  ),
                  vm.loading,
                  (widget) => Stack(
                    children: <Widget>[LinearProgressIndicator(), widget],
                  ),
                ),
    );
  }
}
