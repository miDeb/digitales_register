import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:responsive_scaffold/responsive_scaffold.dart';

import '../container/calendar_container.dart';
import '../container/calendar_week_container.dart';
import '../util.dart';

typedef DayCallback = void Function(DateTime day);

class Calendar extends StatefulWidget {
  final CalendarViewModel vm;

  final DayCallback dayCallback;
  final DayCallback currentMondayCallback;
  final VoidCallback showEditSubjectNicks;
  final VoidCallback closeEditNicksBar;

  const Calendar({
    Key? key,
    required this.vm,
    required this.dayCallback,
    required this.currentMondayCallback,
    required this.showEditSubjectNicks,
    required this.closeEditNicksBar,
  }) : super(key: key);

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResponsiveAppBar(
        title: const Text("Kalender"),
        actions: <Widget>[
          if (toMonday(now) != widget.vm.currentMonday)
            TextButton(
              style: TextButton.styleFrom(
                primary: Theme.of(context).colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              onPressed: () {
                final date = toMonday(now);
                _controller.animateToPage(pageOf(date),
                    curve: _animatePageCurve, duration: _animatePageDuration);
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
                          Theme.of(context).textTheme.headline6),
                    ),
                    onPressed: () async {
                      final result = await showDatePicker(
                        context: context,
                        firstDate: DateTime(2018),
                        lastDate: DateTime(2050),
                        initialDate: widget.vm.currentMonday,
                        selectableDayPredicate: (final day) {
                          return day.weekday != DateTime.sunday &&
                              day.weekday != DateTime.saturday;
                        },
                      );
                      if (result == null) return;
                      final date = toMonday(result);
                      if (date != widget.vm.currentMonday) {
                        _controller.animateToPage(
                          pageOf(date),
                          curve: _animatePageCurve,
                          duration: _animatePageDuration,
                        );
                      }
                    },
                    child: widget.vm.first != null && widget.vm.last != null
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
    );
  }
}

int pageOf(DateTime monday) =>
    monday.difference(DateTime.utc(2010, 1, 3, 0, 0, 0, 0, 1)).inDays ~/ 7;

DateTime mondayOf(int page) =>
    DateTime.utc(2010, 1, 4).add(Duration(days: page * 7));

class EditNickBar extends StatelessWidget {
  final bool show;
  final VoidCallback onShowEditNicks, onClose;

  const EditNickBar(
      {Key? key,
      required this.show,
      required this.onShowEditNicks,
      required this.onClose})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      duration: const Duration(milliseconds: 250),
      firstChild: Column(
        children: <Widget>[
          const SizedBox(
            height: 8,
          ),
          Container(
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
