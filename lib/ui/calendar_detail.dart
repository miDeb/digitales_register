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

import 'package:dr/app_state.dart';
import 'package:dr/container/calendar_card_container.dart';
import 'package:dr/container/calendar_detail_container.dart';
import 'package:dr/ui/calendar_week.dart';
import 'package:dr/ui/no_internet.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../data.dart';
import '../main.dart';

const _pageViewAnimationDuration = Duration(milliseconds: 250);

int _pageViewIndex(DateTime date) {
  return (date.difference(DateTime(1970)).inHours / 24).round();
}

DateTime _dateForPageViewIndex(int idx) {
  final date = DateTime(1970).add(Duration(days: idx));
  // Prevent daylight saving times to interfere.
  // Should have used utc from the beginning...
  return DateTime(date.year, date.month, date.day);
}

class CalendarDetailPage extends StatefulWidget {
  final DateTime? selectedDay;
  final int? selectedHour;
  const CalendarDetailPage({
    Key? key,
    required this.selectedDay,
    required this.selectedHour,
  }) : super(key: key);

  @override
  _CalendarDetailPageState createState() => _CalendarDetailPageState();
}

class _CalendarDetailPageState extends State<CalendarDetailPage> {
  late final PageView _pageView;
  late final PageController _controller;
  DateTime? selectedDate;

  void _pageBack() {
    _controller.previousPage(
      duration: _pageViewAnimationDuration,
      curve: Curves.ease,
    );
  }

  void _pageForward() {
    _controller.nextPage(
      duration: _pageViewAnimationDuration,
      curve: Curves.ease,
    );
  }

  void _handlePageChanged(int index) {
    final date = _dateForPageViewIndex(index);
    actions.calendarActions.select(
      CalendarSelection((b) => b..date = date),
    );
    setState(() {
      selectedDate = date;
    });
  }

  @override
  void didUpdateWidget(CalendarDetailPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    final pageViewIndex = _pageViewIndex(widget.selectedDay!);
    if (pageViewIndex != _controller.page?.round()) {
      _controller.jumpToPage(pageViewIndex);
    }
  }

  @override
  void initState() {
    super.initState();

    _controller = PageController(
      initialPage: _pageViewIndex(widget.selectedDay!),
    );

    _pageView = PageView.builder(
      itemBuilder: (BuildContext context, int index) {
        final date = _dateForPageViewIndex(index);
        return CalendarDetailItemContainer(
          date: date,
          hourIndex: date == widget.selectedDay ? widget.selectedHour : null,
        );
      },
      controller: _controller,
      onPageChanged: _handlePageChanged,
    );
    selectedDate = widget.selectedDay;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          DateFormat.MMMEd("de").format(selectedDate!),
        ),
        actions: [
          IconButton(
            onPressed: _pageBack,
            icon: const Icon(Icons.chevron_left),
          ),
          IconButton(
            onPressed: _pageForward,
            icon: const Icon(Icons.chevron_right),
          ),
        ],
      ),
      body: _pageView,
    );
  }
}

class CalendarDetailWrapper extends StatelessWidget {
  final DateTime date;
  final CalendarDay? day;
  final CalendarHour? targetHour;
  final bool noInternet;
  final bool loading;
  const CalendarDetailWrapper({
    Key? key,
    required this.day,
    required this.targetHour,
    required this.noInternet,
    required this.date,
    required this.loading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Widget child;
    if (day == null && noInternet) {
      child = const NoInternet();
    } else if (day == null && loading) {
      return const Center(child: CircularProgressIndicator());
    } else if (day?.hours.isEmpty ?? true) {
      child = _NoSchool(date: date);
    } else {
      child = CalendarDetail(
        key: ValueKey(day),
        day: day!,
        targetHour: targetHour,
        noInternet: noInternet,
      );
    }
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: child,
    );
  }
}

class CalendarDetail extends StatefulWidget {
  final CalendarDay day;
  final CalendarHour? targetHour;
  final bool noInternet;
  const CalendarDetail({
    Key? key,
    required this.day,
    required this.targetHour,
    required this.noInternet,
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
    return ScrollablePositionedList.builder(
      itemScrollController: itemScrollController,
      itemCount: widget.day.hours.length,
      itemBuilder: (context, index) {
        final hour = widget.day.hours[index];
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8.0,
            vertical: 4,
          ),
          child: CalendarCardContainer(
            hour: hour,
            selected: hour == widget.targetHour,
          ),
        );
      },
    );
  }
}

class _NoSchool extends StatelessWidget {
  final DateTime date;
  const _NoSchool({
    Key? key,
    required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        findHolidayIconForSeason(
          date,
          Theme.of(context).iconTheme.color!,
          150,
        ),
        Text(
          "Keine Schule",
          style: Theme.of(context).textTheme.headline4,
        ),
      ],
    );
  }
}
