import 'package:flutter/material.dart';

import '../app_state.dart';
import '../container/grades_chart_container.dart';
import '../container/grades_page_container.dart';
import '../container/sorted_grades_container.dart';

class GradesPage extends StatelessWidget {
  final GradesPageViewModel vm;

  const GradesPage({Key key, this.vm}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    print(vm.loading);
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
                          .map((s) => DropdownMenuItem(
                                child: Text(
                                  s.name,
                                  style: (Theme.of(context)
                                              .appBarTheme
                                              .textTheme ??
                                          Theme.of(context).primaryTextTheme)
                                      .body1,
                                ),
                                value: s.build(),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (vm.showSemester != value) vm.changeSemester(value);
                      },
                    ),
                  ),
                  data: ThemeData.dark(),
                ),
              ],
      ),
      body: vm.loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              children: <Widget>[
                SizedBox(
                  child: GradesChartContainer(isFullscreen: false),
                  height: 150,
                  width: 250,
                ),
                SortedGradesContainer(),
              ],
            ),
    );
  }
}
