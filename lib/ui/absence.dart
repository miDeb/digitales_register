import 'package:flutter/material.dart';

import '../container/absence_group_container.dart';
import '../data.dart';

class AbsenceGroupWidget extends StatelessWidget {
  final AbsencesViewModel vm;

  const AbsenceGroupWidget({Key key, this.vm}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: vm.justified == AbsenceJustified.notYetJustified ||
                vm.justified == AbsenceJustified.notJustified
            ? BorderSide(color: Colors.red, width: 1)
            : BorderSide(color: Colors.green, width: 0),
        borderRadius: BorderRadius.circular(16),
      ),
      color: Colors.transparent,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            if (vm.reason != null) ...[
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
            ],
            Text(
              vm.fromTo,
              style: Theme.of(context).textTheme.subhead,
            ),
            Text(
              vm.duration,
              style: Theme.of(context).textTheme.body1,
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
            Text(
              vm.justifiedString,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
