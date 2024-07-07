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

import 'package:dr/app_state.dart';
import 'package:dr/container/grades_chart_container.dart';
import 'package:dr/container/grades_page_container.dart';
import 'package:dr/container/sorted_grades_container.dart';
import 'package:dr/ui/animated_linear_progress_indicator.dart';
import 'package:dr/ui/last_fetched_overlay.dart';
import 'package:dr/ui/no_internet.dart';
import 'package:flutter/material.dart';
import 'package:responsive_scaffold/responsive_scaffold.dart';

class GradesPage extends StatelessWidget {
  final GradesPageViewModel vm;
  final ValueChanged<Semester> changeSemester;
  final VoidCallback showGradesSettings;

  const GradesPage({
    super.key,
    required this.vm,
    required this.changeSemester,
    required this.showGradesSettings,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResponsiveAppBar(
        title: const Text("Noten"),
        actions: <Widget>[
          DropdownButtonHideUnderline(
            child: DropdownButton<Semester>(
              value: vm.showSemester,
              items: Semester.values
                  .map(
                    (s) => DropdownMenuItem(
                      value: s,
                      child: Text(
                        s.name,
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (vm.showSemester != value) changeSemester(value!);
              },
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
              : Stack(
                  children: [
                    AnimatedLinearProgressIndicator(show: vm.loading),
                    RawLastFetchedOverlay(
                      message: vm.lastFetchedMessage,
                      child: ListView(
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
                                  const Text("Notendurchschnitt"),
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
                          const SizedBox(height: 50),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }
}
