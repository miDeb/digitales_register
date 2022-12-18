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

import 'package:dr/container/calendar_container.dart';
import 'package:dr/container/calendar_detail_container.dart';
import 'package:dr/container/calendar_week_container.dart';
import 'package:dr/main.dart';
import 'package:dr/utc_date_time.dart';
import 'package:dr/util.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:responsive_scaffold/responsive_scaffold.dart';

const tabletLayoutBreakPoint = 825;

typedef DayCallback = void Function(UtcDateTime day);

class Calendar extends StatefulWidget {
  final CalendarViewModel vm;

  final DayCallback dayCallback;
  final DayCallback currentMondayCallback;
  final VoidCallback showEditSubjectNicks;
  final VoidCallback closeEditNicksBar;

  const Calendar({
    super.key,
    required this.vm,
    required this.dayCallback,
    required this.currentMondayCallback,
    required this.showEditSubjectNicks,
    required this.closeEditNicksBar,
  });

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> with TickerProviderStateMixin {
  late PageController _controller;
  late AnimationController _chevronOpacityController;
  late Animation<double> _chevronOpacityAnimation;
  late AnimationController _dateRangeOpacityController;
  late Animation<double> _dateRangeOpacityAnimation;
  final DateFormat _dateFormat = DateFormat("dd.MM.yy");
  final Curve _animatePageCurve = Curves.ease;
  final Duration _animatePageDuration = const Duration(milliseconds: 200);

  // This page view is created in initState and reused in the build method.
  // While this might not be best practice otherwise, it prevents rebuilds of
  // every currently shown page when the calendar rebuilds. Such rebuilds happen
  // when changing the current page, and would lead to animation janks.
  late PageView _pageView;
  late bool tabletMode;

  static final Animatable<double> _chevronOpacityTween =
      Tween<double>(begin: 1.0, end: 0.0)
          .chain(CurveTween(curve: Curves.easeInOut));
  static final Animatable<double> _dateRangeOpacityTween =
      Tween<double>(begin: 1.0, end: .25)
          .chain(CurveTween(curve: Curves.easeInOut));

  @override
  void initState() {
    _controller = PageController(
      initialPage: pageOf(widget.vm.currentMonday),
    )..addListener(_pageViewControllerListener);

    animatingPages = [pageOf(widget.vm.currentMonday)];

    _chevronOpacityController = AnimationController(
      duration: _animatePageDuration,
      vsync: this,
    );
    _chevronOpacityAnimation =
        _chevronOpacityController.drive(_chevronOpacityTween);

    _dateRangeOpacityController = AnimationController(
      duration: _animatePageDuration,
      vsync: this,
    );
    _dateRangeOpacityAnimation =
        _dateRangeOpacityController.drive(_dateRangeOpacityTween);

    widget.dayCallback(widget.vm.currentMonday);

    _pageView = PageView.builder(
      itemBuilder: (BuildContext context, int index) {
        return CalendarWeekContainer(
          monday: mondayOf(index),
        );
      },
      controller: _controller,
      onPageChanged: _handlePageChanged,
    );

    super.initState();
  }

  late List<int> animatingPages;

  void _pageViewControllerListener() {
    final floor = _controller.page!.floor(), ceil = _controller.page!.ceil();
    if (!animatingPages.contains(floor)) {
      widget.dayCallback(mondayOf(floor));
    }
    if (ceil != floor && !animatingPages.contains(ceil)) {
      widget.dayCallback(mondayOf(ceil));
    }
    animatingPages = [floor, ceil];
  }

  void _handlePageChanged(int newPage) {
    final newMonday = mondayOf(newPage);
    if (newMonday != widget.vm.currentMonday) {
      widget.currentMondayCallback(newMonday);
    }
  }

  @override
  void dispose() {
    _chevronOpacityController.dispose();
    _dateRangeOpacityController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant Calendar oldWidget) {
    final page = pageOf(widget.vm.currentMonday);
    if (page != _controller.page?.round()) {
      _controller.animateToPage(
        page,
        curve: _animatePageCurve,
        duration: _animatePageDuration,
      );
    }
    if (!tabletMode &&
        oldWidget.vm.selection == null &&
        widget.vm.selection != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context)
            .push<void>(
              MaterialPageRoute(
                builder: (context) => const CalendarDetailContainer(
                  isSidebar: false,
                  show: true,
                ),
                fullscreenDialog: true,
              ),
            )
            .then((_) => actions.calendarActions.select(null));
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      tabletMode = constraints.maxWidth >= tabletLayoutBreakPoint;
      return Row(
        children: [
          Expanded(
            child: Stack(
              children: [
                Scaffold(
                  appBar: ResponsiveAppBar(
                    title: const Text("Kalender"),
                    actions: <Widget>[
                      if (toMonday(now) != widget.vm.currentMonday)
                        TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor:
                                Theme.of(context).colorScheme.onPrimary,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                          ),
                          onPressed: () {
                            final date = toMonday(now);
                            _controller.animateToPage(pageOf(date),
                                curve: _animatePageCurve,
                                duration: _animatePageDuration);
                          },
                          child: const Text(
                            "Aktuelle Woche",
                          ),
                        ),
                    ],
                  ),
                  body: Column(
                    children: <Widget>[
                      Material(
                        clipBehavior: Clip.antiAlias,
                        elevation: 4,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: FadeTransition(
                                opacity: _chevronOpacityAnimation,
                                child: TextButton(
                                  onPressed: () {
                                    _controller.previousPage(
                                      curve: _animatePageCurve,
                                      duration: _animatePageDuration,
                                    );
                                  },
                                  child: const Icon(Icons.chevron_left),
                                ),
                              ),
                            ),
                            FadeTransition(
                              opacity: _dateRangeOpacityAnimation,
                              child: TextButton(
                                style: ButtonStyle(
                                  textStyle: MaterialStateProperty.all(
                                      Theme.of(context).textTheme.titleLarge),
                                ),
                                onPressed: () async {
                                  final result = await showDatePicker(
                                    context: context,
                                    firstDate: UtcDateTime(2018),
                                    lastDate: UtcDateTime(2050),
                                    initialDate: widget.vm.currentMonday,
                                    selectableDayPredicate: (day) {
                                      return day.weekday != DateTime.sunday &&
                                          day.weekday != DateTime.saturday;
                                    },
                                  );
                                  if (result == null) return;
                                  final date = toMonday(result.makeUtc());
                                  if (date != widget.vm.currentMonday) {
                                    await _controller.animateToPage(
                                      pageOf(date),
                                      curve: _animatePageCurve,
                                      duration: _animatePageDuration,
                                    );
                                  }
                                },
                                child: widget.vm.first != null &&
                                        widget.vm.last != null
                                    ? Text(
                                        "${_dateFormat.format(widget.vm.first!)} - ${_dateFormat.format(widget.vm.last!)}",
                                      )
                                    : widget.vm.noInternet
                                        ? const Text("Wähle ein Datum")
                                        : const CircularProgressIndicator(),
                              ),
                            ),
                            Expanded(
                              child: FadeTransition(
                                opacity: _chevronOpacityAnimation,
                                child: TextButton(
                                  onPressed: () {
                                    _controller.nextPage(
                                        curve: _animatePageCurve,
                                        duration: _animatePageDuration);
                                  },
                                  child: const Icon(Icons.chevron_right),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Expanded(
                        child: NotificationListener<ScrollStartNotification>(
                          onNotification: (n) {
                            _chevronOpacityController.forward();
                            _dateRangeOpacityController.forward();
                            return false;
                          },
                          child: NotificationListener<ScrollEndNotification>(
                            onNotification: (_) {
                              _chevronOpacityController.reverse();
                              _dateRangeOpacityController.reverse();
                              return false;
                            },
                            child: _pageView,
                          ),
                        ),
                      ),
                      EditNickBar(
                        show: widget.vm.showEditNicksBar,
                        onShowEditNicks: widget.showEditSubjectNicks,
                        onClose: widget.closeEditNicksBar,
                      ),
                    ],
                  ),
                ),
                if (tabletMode && widget.vm.selection != null)
                  Positioned(
                    right: 0,
                    top: -4,
                    bottom: -4,
                    child: ClipRect(
                      child: Container(
                        width: 5,
                        decoration: const BoxDecoration(
                          color: Colors.transparent,
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(7, 0),
                              blurRadius: 4,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          CalendarDetailContainer(
            isSidebar: true,
            show: tabletMode,
          ),
        ],
      );
    });
  }
}

int pageOf(UtcDateTime monday) =>
    monday.difference(UtcDateTime(2010, 1, 3, 0, 0, 0, 0, 1)).inDays ~/ 7;

UtcDateTime mondayOf(int page) =>
    UtcDateTime(2010, 1, 4).add(Duration(days: page * 7));

class EditNickBar extends StatelessWidget {
  final bool show;
  final VoidCallback onShowEditNicks, onClose;

  const EditNickBar(
      {super.key,
      required this.show,
      required this.onShowEditNicks,
      required this.onClose});
  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      duration: const Duration(milliseconds: 250),
      firstChild: Column(
        children: <Widget>[
          const SizedBox(
            height: 8,
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0, -1.5),
                  spreadRadius: 1.5,
                  blurRadius: 2,
                ),
              ],
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
            child: Material(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: TextButton(
                        onPressed: onShowEditNicks,
                        child: Row(
                          children: const [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Text("Kürzel bearbeiten"),
                            ),
                            Spacer(),
                          ],
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: onClose,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      secondChild: Container(
        height: 8,
      ),
      crossFadeState:
          show ? CrossFadeState.showFirst : CrossFadeState.showSecond,
    );
  }
}
