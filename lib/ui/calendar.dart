import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';

import '../container/calendar_container.dart';
import '../container/calendar_week_container.dart';
import '../util.dart';

class Calendar extends StatefulWidget {
  final CalendarViewModel vm;

  const Calendar({Key key, this.vm}) : super(key: key);

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> with TickerProviderStateMixin {
  PageController _controller;
  DateTime _currentMonday;
  AnimationController _chevronOpacityController;
  Animation<double> _chevronOpacityAnimation;
  AnimationController _dateRangeOpacityController;
  Animation<double> _dateRangeOpacityAnimation;
  final DateFormat _dateFormat = DateFormat("dd.MM.yy");
  final Curve _animatePageCurve = Curves.ease;
  final Duration _animatePageDuration = const Duration(milliseconds: 200);

  static final Animatable<double> _chevronOpacityTween =
      Tween<double>(begin: 1.0, end: 0.0)
          .chain(CurveTween(curve: Curves.easeInOut));
  static final Animatable<double> _dateRangeOpacityTween =
      Tween<double>(begin: 1.0, end: .25)
          .chain(CurveTween(curve: Curves.easeInOut));

  @override
  void initState() {
    _currentMonday = toMonday(DateTime.now());
    _controller = PageController(
      initialPage: pageOf(_currentMonday),
    )..addListener(_pageViewControllerListener);

    animatingPages = [pageOf(_currentMonday)];

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

    widget.vm.dayCallback(_currentMonday);

    super.initState();
  }

  List<int> animatingPages;

  void _pageViewControllerListener() {
    final floor = _controller.page.floor(), ceil = _controller.page.ceil();
    if (!animatingPages.contains(floor)) {
      widget.vm.dayCallback(mondayOf(floor));
    }
    if (ceil != floor && !animatingPages.contains(ceil)) {
      widget.vm.dayCallback(mondayOf(ceil));
    }
    animatingPages = [floor, ceil];
  }

  void _handlePageChanged(int newPage) {
    final newMonday = mondayOf(newPage);
    if (newMonday != _currentMonday) {
      setState(() {
        _currentMonday = newMonday;
      });
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
      appBar: AppBar(
        title: Text("Kalender"),
        actions: <Widget>[
          if (toMonday(DateTime.now()) != _currentMonday)
            FlatButton(
              textColor: Colors.white,
              child: Text("Aktuelle Woche"),
              onPressed: () {
                final date = toMonday(DateTime.now());
                if (date != _currentMonday) {
                  _controller.animateToPage(pageOf(date),
                      curve: _animatePageCurve, duration: _animatePageDuration);
                }
              },
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
                    child: FlatButton(
                      child: Icon(Icons.chevron_left),
                      onPressed: () {
                        _controller.previousPage(
                          curve: _animatePageCurve,
                          duration: _animatePageDuration,
                        );
                      },
                    ),
                  ),
                ),
                InkWell(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: FadeTransition(
                      opacity: _dateRangeOpacityAnimation,
                      child: Text(
                        "${_dateFormat.format(_currentMonday)} - ${_dateFormat.format(_currentMonday.add(Duration(days: 4)))}",
                        style: Theme.of(context).textTheme.title,
                      ),
                    ),
                  ),
                  onTap: () async {
                    final result = await showDatePicker(
                        context: context,
                        firstDate: DateTime(2018),
                        lastDate: DateTime(2050),
                        initialDate: _currentMonday,
                        selectableDayPredicate: (final day) {
                          return day.weekday != DateTime.sunday &&
                              day.weekday != DateTime.saturday;
                        });
                    if (result == null) return;
                    final date = toMonday(result);
                    if (date != _currentMonday) {
                      _controller.animateToPage(
                        pageOf(date),
                        curve: _animatePageCurve,
                        duration: _animatePageDuration,
                      );
                    }
                  },
                ),
                Expanded(
                  child: FadeTransition(
                    opacity: _chevronOpacityAnimation,
                    child: FlatButton(
                      child: Icon(Icons.chevron_right),
                      onPressed: () {
                        _controller.nextPage(
                            curve: _animatePageCurve,
                            duration: _animatePageDuration);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
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
                child: PageView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    return CalendarWeekContainer(
                      monday: mondayOf(index),
                    );
                  },
                  controller: _controller,
                  onPageChanged: _handlePageChanged,
                ),
              ),
            ),
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
