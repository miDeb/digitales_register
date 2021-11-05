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

import 'package:dr/container/calendar_card_container.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../data.dart';

class CalendarDetail extends StatefulWidget {
  final CalendarDay day;
  final CalendarHour? targetHour;
  const CalendarDetail({
    Key? key,
    required this.day,
    required this.targetHour,
  }) : super(key: key);

  @override
  State<CalendarDetail> createState() => _CalendarDetailState();
}

class _CalendarDetailState extends State<CalendarDetail> {
  final ItemScrollController itemScrollController = ItemScrollController();

  @override
  void initState() {
    super.initState();
    final targetHour = widget.targetHour;
    if (targetHour != null) {
      // Run this after the next frame
      WidgetsBinding.instance!.addPostFrameCallback(
        (_) {
          itemScrollController.jumpTo(
            index: widget.day.hours.indexOf(targetHour),
            alignment: 0.10,
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          DateFormat.MMMMd("de").format(widget.day.date),
        ),
      ),
      body: ScrollablePositionedList.builder(
        itemScrollController: itemScrollController,
        itemCount: widget.day.hours.length,
        itemBuilder: (context, index) {
          final hour = widget.day.hours[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
            child: CalendarCardContainer(
              hour: hour,
              selected: hour == widget.targetHour,
            ),
          );
        },
      ),
    );
  }
}
