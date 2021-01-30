import 'package:flutter/material.dart';
import 'package:responsive_scaffold/responsive_scaffold.dart';

import '../app_state.dart';
import '../container/grades_chart_container.dart';
import '../container/grades_page_container.dart';
import '../container/sorted_grades_container.dart';
import '../util.dart';
import 'no_internet.dart';

class GradesPage extends StatelessWidget {
  final GradesPageViewModel vm;
  final ValueChanged<Semester> changeSemester;
  final VoidCallback showGradesSettings;

  const GradesPage({
    Key key,
    @required this.vm,
    @required this.changeSemester,
    @required this.showGradesSettings,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResponsiveAppBar(
        title: const Text("Noten"),
        actions: <Widget>[
          Theme(
            data: ThemeData.dark(),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<Semester>(
                value: vm.showSemester,
                items: Semester.values
                    .map(
                      (s) => DropdownMenuItem(
                        value: s,
                        child: Text(
                          s.name,
                          style: (Theme.of(context).appBarTheme.textTheme ??
                                  Theme.of(context).primaryTextTheme)
                              .bodyText2,
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (vm.showSemester != value) changeSemester(value);
                },
              ),
            ),
          ),
        ],
      ),
      body: !vm.hasData && vm.noInternet
          ? const NoInternet()
          : vm.loading && !vm.hasData
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : maybeWrap(
                  ListView(
                    children: <Widget>[
                      if (vm.showGradesDiagram)
                        const SizedBox(
                          height: 150,
                          width: 250,
                          child: GradesChartContainer(isFullscreen: false),
                        ),
                      if (vm.showAllSubjectsAverage) ...[
                        ListTile(
                          title: Row(
                            children: [
                              const Text("Ø aller Fächer"),
                              IconButton(
                                icon: const Icon(Icons.settings),
                                onPressed: showGradesSettings,
                              ),
                            ],
                          ),
                          trailing: Text(vm.allSubjectsAverage),
                        ),
                        const Divider(
                          height: 0,
                        ),
                      ],
                      SortedGradesContainer(),
                    ],
                  ),
                  (widget) => Stack(
                    children: [const LinearProgressIndicator(), widget],
                  ),
                  wrap: vm.loading,
                ),
    );
  }
}
