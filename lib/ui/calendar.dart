import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';

import '../container/calendar_container.dart';
import '../container/calendar_week_container.dart';
import '../util.dart';
import 'my_date_picker.dart';

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
    _currentMonday = widget.vm.currentMonday;
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

    widget.vm.dayCallback(widget.vm.currentMonday);

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

  @override
  didUpdateWidget(Calendar oldWidget) {
    if (widget.vm.currentMonday != _currentMonday) {
      _controller.animateToPage(
        pageOf(widget.vm.currentMonday),
        curve: _animatePageCurve,
        duration: _animatePageDuration,
      );
      _currentMonday = widget.vm.currentMonday;
    }
    super.didUpdateWidget(oldWidget);
  }

  void _handlePageChanged(int newPage) {
    final newMonday = mondayOf(newPage);
    if (newMonday != _currentMonday) {
      setState(() {
        _currentMonday = newMonday;
      });
      widget.vm.currentMondayChanged(newMonday);
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
              child: Text("Heute"),
              onPressed: () {
                final date = toMonday(DateTime.now());
                if (date != _currentMonday) {
                  _controller.animateToPage(pageOf(date),
                      curve: _animatePageCurve, duration: _animatePageDuration);
                  // setState(() {
                  //   _currentMonday = date;
                  // });
                }
              },
            ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Card(
            clipBehavior: Clip.antiAlias,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(
                  child: FadeTransition(
                    opacity: _chevronOpacityAnimation,
                    child: InkWell(
                      child: Padding(
                        padding: const EdgeInsets.all(9).copyWith(right: 8),
                        child: Icon(Icons.chevron_left),
                      ),
                      onTap: () {
                        _controller.previousPage(
                            curve: _animatePageCurve,
                            duration: _animatePageDuration);
                        //widget.vm.prevWeek();
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
                        "${_dateFormat.format(_currentMonday)} - ${_dateFormat.format(_currentMonday.add(Duration(days: 6)))}",
                        style: Theme.of(context).textTheme.title,
                      ),
                    ),
                  ),
                  onTap: () async {
                    final result = await showMyDatePicker(
                        context: context,
                        firstDate: DateTime(2018),
                        lastDate: DateTime(2020),
                        initialDate: _currentMonday);
                    if (result == null) return;
                    final date = toMonday(result);
                    if (date != _currentMonday) {
                      _controller.animateToPage(pageOf(date),
                          curve: _animatePageCurve,
                          duration: _animatePageDuration);
                      // setState(() {
                      //   _currentMonday = date;
                      // });
                      //widget.vm.dayCallback(date);
                    }
                  },
                ),
                Expanded(
                  child: FadeTransition(
                    opacity: _chevronOpacityAnimation,
                    child: InkWell(
                      child: Padding(
                        padding: const EdgeInsets.all(9).copyWith(left: 8),
                        child: Icon(Icons.chevron_right),
                      ),
                      onTap: () {
                        _controller.nextPage(
                            curve: _animatePageCurve,
                            duration: _animatePageDuration);
                        //widget.vm.nextWeek();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: NotificationListener<ScrollStartNotification>(
              onNotification: (n) {
                _chevronOpacityController.forward();
                _dateRangeOpacityController.forward();
              },
              child: NotificationListener<ScrollEndNotification>(
                onNotification: (_) {
                  _chevronOpacityController.reverse();
                  _dateRangeOpacityController.reverse();
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
