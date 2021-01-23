import 'package:dr/app_state.dart';
import 'package:flutter/material.dart';

typedef SetThickness = void Function(int thickness);

class GradesChartLegendEntry extends StatelessWidget {
  final SubjectGraphConfig config;
  final String name;
  final SetThickness setThickness;

  // calls to setThickness are delayed by 100 ms to reduce jankiness. This leads
  // to some weird code.
  const GradesChartLegendEntry(
      {Key key, this.config, this.name, this.setThickness})
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
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                name,
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
            flex: 3,
          ),
          Expanded(
            child: StatefulBuilder(builder: (context, setState) {
              return Slider(
                onChanged: (double val) {
                  final thisCall = ++call;
                  final value = val.toInt();
                  if (value == config.thick) return;
                  setState(() {
                    thickness = val;
                  });
                  Future.delayed(Duration(milliseconds: 100), () {
                    if (call != thisCall || value == config.thick) {
                      return;
                    }
                    setThickness(value);
                  });
                },
                value: thickness,
                min: 0,
                max: 5,
                divisions: 5,
                activeColor: Color(config.color),
                inactiveColor: Color(config.color).withOpacity(0.2),
              );
            }),
            flex: 2,
          ),
        ],
      ),
    );
  }
}
