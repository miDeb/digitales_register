import 'package:badges/badges.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';

import '../container/homework_filter_container.dart';
import '../data.dart';

typedef HomeworkBlacklistCallback = void Function(
    ListBuilder<HomeworkType> blacklist);

class HomeworkFilter extends StatefulWidget {
  final HomeworkFilterVM vm;
  final HomeworkBlacklistCallback callback;

  const HomeworkFilter({Key? key, required this.vm, required this.callback})
      : super(key: key);

  @override
  _HomeworkFilterState createState() => _HomeworkFilterState();
}

class _HomeworkFilterState extends State<HomeworkFilter>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ExpansionTile(
      title: const SizedBox(),
      trailing: Padding(
        padding: const EdgeInsets.only(right: 8),
        child: Badge(
          badgeContent: Container(
            color: Colors.red,
          ),
          showBadge: widget.vm.currentBlacklist.isNotEmpty,
          child: const Icon(Icons.filter_list),
        ),
      ),
      children: [
        CheckboxListTile(
          onChanged: (v) => widget.callback(
            v!
                ? (widget.vm.currentBlacklist.toBuilder()
                  ..remove(HomeworkType.grade)
                  ..remove(HomeworkType.gradeGroup))
                : (widget.vm.currentBlacklist.toBuilder()
                  ..add(HomeworkType.grade)
                  ..add(HomeworkType.gradeGroup)),
          ),
          title: const Text("Noten & Tests"),
          value: !widget.vm.currentBlacklist.contains(HomeworkType.grade),
        ),
        CheckboxListTile(
            onChanged: (v) => widget.callback(
                  v!
                      ? (widget.vm.currentBlacklist.toBuilder()
                        ..remove(HomeworkType.homework)
                        ..remove(HomeworkType.lessonHomework))
                      : (widget.vm.currentBlacklist.toBuilder()
                        ..add(HomeworkType.homework)
                        ..add(HomeworkType.lessonHomework)),
                ),
            title: const Text("Hausaufgaben & Erinnerungen"),
            value: !widget.vm.currentBlacklist.contains(HomeworkType.homework)),
        CheckboxListTile(
          onChanged: (v) => widget.callback(
            v!
                ? (widget.vm.currentBlacklist.toBuilder()
                  ..remove(HomeworkType.observation))
                : (widget.vm.currentBlacklist.toBuilder()
                  ..add(HomeworkType.observation)),
          ),
          title: const Text("Beobachtungen"),
          value: !widget.vm.currentBlacklist.contains(HomeworkType.observation),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
