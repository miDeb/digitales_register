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
import 'package:flutter/material.dart';

typedef SetThickness = void Function(int thickness);

class GradesChartLegendEntry extends StatelessWidget {
  final SubjectTheme config;
  final String name;
  final SetThickness setThickness;

  // calls to setThickness are delayed by 100 ms to reduce jankiness. This leads
  // to some weird code.
  const GradesChartLegendEntry(
      {Key? key,
      required this.config,
      required this.name,
      required this.setThickness})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    var thickness = config.thick.toDouble();
    var call = 0;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                name,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: StatefulBuilder(builder: (context, setState) {
              return Slider(
                onChanged: (double val) {
                  final thisCall = ++call;
                  final value = val.toInt();
                  if (value == config.thick) return;
                  setState(() {
                    thickness = val;
                  });
                  Future.delayed(const Duration(milliseconds: 100), () {
                    if (call != thisCall || value == config.thick) {
                      return;
                    }
                    setThickness(value);
                  });
                },
                value: thickness,
                max: 5,
                divisions: 5,
                activeColor: Color(config.color),
                inactiveColor: Color(config.color).withOpacity(0.2),
              );
            }),
          ),
        ],
      ),
    );
  }
}
