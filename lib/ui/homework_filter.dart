import 'package:dr/container/homework_filter_container.dart';
import 'package:dr/data.dart';
import 'package:flutter/material.dart';

class HomeworkFilter extends StatefulWidget {
  final HomeworkFilterVM vm;

  const HomeworkFilter({Key key, this.vm}) : super(key: key);

  @override
  _HomeworkFilterState createState() => _HomeworkFilterState();
}

class _HomeworkFilterState extends State<HomeworkFilter>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ExpansionTile(
        title: Row(
          children: <Widget>[
            Spacer(),
            Icon(Icons.filter_list),
          ],
        ),
        children: [
          CheckboxListTile(
              onChanged: (v) => widget.vm.callback(v
                  ? (widget.vm.currentBlacklist
                    ..remove(HomeworkType.grade)
                    ..remove(HomeworkType.gradeGroup))
                  : (widget.vm.currentBlacklist
                    ..add(HomeworkType.grade)
                    ..add(HomeworkType.gradeGroup))),
              title: Text("Noten & Tests"),
              value: !widget.vm.currentBlacklist.contains(HomeworkType.grade)),
          CheckboxListTile(
              onChanged: (v) => widget.vm.callback(v
                  ? (widget.vm.currentBlacklist
                    ..remove(HomeworkType.homework)
                    ..remove(HomeworkType.lessonHomework))
                  : (widget.vm.currentBlacklist
                    ..add(HomeworkType.homework)
                    ..add(HomeworkType.lessonHomework))),
              title: Text("Hausaufgaben & Erinnerungen"),
              value:
                  !widget.vm.currentBlacklist.contains(HomeworkType.homework)),
          CheckboxListTile(
              onChanged: (v) => widget.vm.callback(v
                  ? (widget.vm.currentBlacklist
                    ..remove(HomeworkType.observation))
                  : (widget.vm.currentBlacklist
                    ..add(HomeworkType.observation))),
              title: Text("Beobachtungen"),
              value: !widget.vm.currentBlacklist
                  .contains(HomeworkType.observation)),
        ]);
  }

  @override
  bool get wantKeepAlive => true;
}
