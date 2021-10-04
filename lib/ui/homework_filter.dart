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
