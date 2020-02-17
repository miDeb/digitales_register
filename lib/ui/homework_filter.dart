import 'package:badges/badges.dart';
import 'package:flutter/material.dart';

import '../container/homework_filter_container.dart';
import '../data.dart';

typedef HomeworkBlacklistCallback = void Function(List<HomeworkType> blacklist);

class HomeworkFilter extends StatefulWidget {
  final HomeworkFilterVM vm;
  final HomeworkBlacklistCallback callback;

  const HomeworkFilter({Key key, this.vm, this.callback}) : super(key: key);

  @override
  _HomeworkFilterState createState() => _HomeworkFilterState();
}

class _HomeworkFilterState extends State<HomeworkFilter>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ExpansionTile(
      title: SizedBox(),
      trailing: Padding(
        padding: const EdgeInsets.only(right: 8),
        child: Badge(
          child: Icon(Icons.filter_list),
          badgeContent: Container(
            color: Colors.red,
          ),
          showBadge: widget.vm.currentBlacklist.isNotEmpty,
        ),
      ),
      children: [
        CheckboxListTile(
          onChanged: (v) => widget.callback(
            v
                ? (widget.vm.currentBlacklist
                  ..remove(HomeworkType.grade)
                  ..remove(HomeworkType.gradeGroup))
                : (widget.vm.currentBlacklist
                  ..add(HomeworkType.grade)
                  ..add(HomeworkType.gradeGroup)),
          ),
          title: Text("Noten & Tests"),
          value: !widget.vm.currentBlacklist.contains(HomeworkType.grade),
        ),
        CheckboxListTile(
            onChanged: (v) => widget.callback(
                  v
                      ? (widget.vm.currentBlacklist
                        ..remove(HomeworkType.homework)
                        ..remove(HomeworkType.lessonHomework))
                      : (widget.vm.currentBlacklist
                        ..add(HomeworkType.homework)
                        ..add(HomeworkType.lessonHomework)),
                ),
            title: Text("Hausaufgaben & Erinnerungen"),
            value: !widget.vm.currentBlacklist.contains(HomeworkType.homework)),
        CheckboxListTile(
          onChanged: (v) => widget.callback(
            v
                ? (widget.vm.currentBlacklist..remove(HomeworkType.observation))
                : (widget.vm.currentBlacklist..add(HomeworkType.observation)),
          ),
          title: Text("Beobachtungen"),
          value: !widget.vm.currentBlacklist.contains(HomeworkType.observation),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
