import 'package:flutter/material.dart';

import '../container/absence_group_container.dart';
import '../data.dart';

class AbsenceGroupWidget extends StatelessWidget {
  final AbsencesViewModel vm;

  const AbsenceGroupWidget({Key key, this.vm}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: .6,
      shape: RoundedRectangleBorder(
        side: vm.justified == AbsenceJustified.notYetJustified
            ? BorderSide(color: Colors.red, width: 2)
            : vm.justified == AbsenceJustified.notJustified
                ? BorderSide(color: Colors.orange, width: 2)
                : BorderSide(color: Colors.green, width: 2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Text(vm.reason),
            Row(
              children: <Widget>[
                Spacer(),
                Flexible(
                  child: Divider(
                    height: 8,
                  ),
                  flex: 48,
                ),
                Spacer(),
              ],
            ),
            Text(
              vm.fromTo,
              style: Theme.of(context).textTheme.subhead,
            ),
            Text(
              vm.duration,
              style: Theme.of(context)
                  .textTheme
                  .body1,
            ),
            Row(
              children: <Widget>[
                Spacer(),
                Flexible(
                  child: Divider(
                    height: 8,
                  ),
                  flex: 48,
                ),
                Spacer(),
              ],
            ),
            Text(vm.justifiedString, textAlign: TextAlign.center,),
          ],
        ),
      ),
    );
  }
}
