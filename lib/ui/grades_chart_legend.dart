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
