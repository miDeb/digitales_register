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
import 'package:dr/container/calendar_detail_container.dart';
import 'package:dr/ui/calendar_week.dart';
import 'package:dr/ui/last_fetched_overlay.dart';
import 'package:dr/ui/no_internet.dart';
import 'package:dr/util.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:responsive_scaffold/size_transition.dart' as rsc;
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../app_state.dart';
import '../data.dart';
import '../main.dart';
import '../utc_date_time.dart';

const _pageViewAnimationDuration = Duration(milliseconds: 250);

class RightSidebar extends StatefulWidget {
  final Widget child;
  final bool show;
  const RightSidebar({
    Key? key,
    required this.child,
    required this.show,
  }) : super(key: key);

  @override
  State<RightSidebar> createState() => _RightSidebarState();
}

class _RightSidebarState extends State<RightSidebar>
    with SingleTickerProviderStateMixin {
  late final _animationController = AnimationController(
    vsync: this,
    duration: _pageViewAnimationDuration,
    value: 0,
  );
  @override
  void didUpdateWidget(RightSidebar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.show != widget.show) {
      _animationController.animateTo(
        widget.show ? 1.0 : 0.0,
        duration: _pageViewAnimationDuration,
        curve: Curves.ease,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return rsc.SizeTransition(
      axis: Axis.horizontal,
      sizeFactor: _animationController,
      axisAlignment: -1,
      child: SizedBox(
        width: 350,
        child: widget.child,
      ),
    );
  }
}

int _pageViewIndex(UtcDateTime date) {
  return (date.difference(UtcDateTime(1970)).inHours / 24).round();
}

UtcDateTime _dateForPageViewIndex(int idx) {
  final date = UtcDateTime(1970).add(Duration(days: idx));
  // Prevent daylight saving times to interfere.
  // Should have used utc from the beginning...
  return UtcDateTime(date.year, date.month, date.day);
}

class CalendarDetailPage extends StatefulWidget {
  final UtcDateTime? selectedDay;
  final int? selectedHour;
  final bool isSidebar, show;
  const CalendarDetailPage({
    Key? key,
    required this.selectedDay,
    required this.selectedHour,
    required this.isSidebar,
    required this.show,
  }) : super(key: key);

  @override
  _CalendarDetailPageState createState() => _CalendarDetailPageState();
}

class _CalendarDetailPageState extends State<CalendarDetailPage> {
  late final PageView _pageView;
  late final PageController _controller;
  UtcDateTime? selectedDate;
  int programmaticPageAnimations = 0;

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
    if (programmaticPageAnimations != 0) {
      return;
    }
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
    if (!widget.show && oldWidget.show) {
      // clear the selection
      actions.calendarActions.select(null);
    }
    if (!widget.show) {
      return;
    }
    if (widget.selectedDay == null) {
      return;
    }
    final pageViewIndex = _pageViewIndex(widget.selectedDay!);
    if (pageViewIndex != _controller.page?.round()) {
      selectedDate = widget.selectedDay;
      if (oldWidget.selectedDay != null) {
        programmaticPageAnimations++;
        _controller
            .animateToPage(
          pageViewIndex,
          duration: _pageViewAnimationDuration,
          curve: Curves.ease,
        )
            .then((_) {
          programmaticPageAnimations--;
        });
      } else {
        // We were previouly closed, so we don't want to show a page animation.
        programmaticPageAnimations++;
        _controller.jumpToPage(pageViewIndex);
        programmaticPageAnimations--;
      }
    }
  }

  @override
  void initState() {
    super.initState();

    _controller = PageController(
      initialPage:
          widget.selectedDay != null ? _pageViewIndex(widget.selectedDay!) : 0,
    );

    _pageView = PageView.builder(
      itemBuilder: (BuildContext context, int index) {
        final date = _dateForPageViewIndex(index);
        return CalendarDetailItemContainer(
          date: date,
          isSidebar: widget.isSidebar,
        );
      },
      controller: _controller,
      onPageChanged: _handlePageChanged,
    );

    selectedDate = widget.selectedDay;
  }

  @override
  Widget build(BuildContext context) {
    return maybeWrap(
      Scaffold(
        appBar: AppBar(
          leading: widget.isSidebar
              ? IconButton(
                  icon: const Icon(Icons.arrow_forward_ios),
                  onPressed: () {
                    actions.calendarActions.select(null);
                  },
                )
              : null,
          title: Text(
            selectedDate != null
                ? DateFormat.MMMEd("de").format(selectedDate!)
                : "Detailansicht",
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
      ),
      (scaffold) => RightSidebar(
        show: widget.selectedDay != null && widget.show,
        child: scaffold,
      ),
      wrap: widget.isSidebar,
    );
  }
}

class CalendarDetailWrapper extends StatelessWidget {
  final UtcDateTime date;
  final CalendarDay? day;
  final CalendarHour? targetHour;
  final bool noInternet;
  final bool loading;
  final bool isSidebar;
  const CalendarDetailWrapper({
    Key? key,
    required this.day,
    required this.targetHour,
    required this.noInternet,
    required this.date,
    required this.loading,
    required this.isSidebar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (day == null && noInternet) {
      child = const NoInternet();
    } else if (day == null && loading) {
      return const Center(child: CircularProgressIndicator());
    } else if (day?.hours.isEmpty ?? true) {
      child = _NoSchool(date: date);
    } else {
      child = CalendarDetail(
        day: day!,
        targetHour: targetHour,
        noInternet: noInternet,
      );
    }
    if (day != null && !isSidebar) {
      child = LastFetchedOverlay(
        noInternet: noInternet,
        lastFetched: day!.lastFetched,
        child: child,
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
  void didUpdateWidget(covariant CalendarDetail oldWidget) {
    final targetHour = widget.targetHour;
    if (targetHour != null && targetHour != oldWidget.targetHour) {
      itemScrollController.scrollTo(
        index: widget.day.hours.indexOf(targetHour),
        alignment: 0.10,
        duration: const Duration(milliseconds: 250),
        curve: Curves.ease,
      );
    }

    super.didUpdateWidget(oldWidget);
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
            day: widget.day.date,
          ),
        );
      },
    );
  }
}

class _NoSchool extends StatelessWidget {
  final UtcDateTime date;
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
