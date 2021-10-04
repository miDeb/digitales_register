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

import 'package:built_collection/built_collection.dart';
import 'package:dr/container/chart_legend_entry_container.dart';
import 'package:flutter/material.dart';

class ChartLegend extends StatelessWidget {
  final BuiltList<String> vm;

  const ChartLegend({Key? key, required this.vm}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return ExpansionTile(
      title: const Text("Legende"),
      children: <Widget>[
        // supports the case when there are not enough subjects to fill the available vertical space.
        // this is, however, quite unlikely.
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: height / 2 - 90,
          ),
          child: ListView.builder(
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return ChartLegendEntryContainer(
                subjectName: vm[index],
              );
            },
            itemCount: vm.length,
          ),
        )
      ],
    );
  }
}
