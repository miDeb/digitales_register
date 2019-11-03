import 'package:flutter/material.dart';

import '../container/chart_legend_container.dart';

class ChartLegend extends StatelessWidget {
  final ChartLegendViewModel vm;

  const ChartLegend({Key key, this.vm}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    int call = 0;
    return ExpansionTile(
      title: Text("Legende"),
      children: <Widget>[
        Container(
          height: height / 2 - 90,
          child: ListView(
            children: vm.configs.entries.map((entry) {
              var thickness = entry.value.thick.toDouble();
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  children: [
                    Container(
                      width: 30,
                      height: 12,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                        ),
                        child: Center(
                          child: Container(
                            height: thickness,
                            decoration: BoxDecoration(
                                color: Color(entry.value.color),
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(7),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          entry.key,
                          style: Theme.of(context).textTheme.subhead,
                        ),
                      ),
                      flex: 3,
                    ),
                    Expanded(
                      child: StatefulBuilder(
                        builder: (context, setState) => Slider(
                          onChanged: (double value) {
                            if (value.toInt() == thickness) return;
                            final _call = ++call;
                            setState(() {
                              thickness = value;
                            });
                            Future.delayed(Duration(milliseconds: 100), () {
                              if (call != _call ||
                                  value.toInt() == entry.value.thick) return;
                              vm.onChangeThick(entry.key, value.toInt());
                            });
                          },
                          value: thickness,
                          min: 0,
                          max: 5,
                          divisions: 5,
                          activeColor: Theme.of(context).accentColor,
                        ),
                      ),
                      flex: 2,
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        )
      ],
    );
  }
}
