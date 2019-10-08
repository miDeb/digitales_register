import 'package:dr/container/homework_filter_container.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../container/days_container.dart';
import '../data.dart';
import '../util.dart';
import 'dialog.dart';
import 'news_sticker.dart';

class DaysWidget extends StatefulWidget {
  final DaysViewModel vm;

  const DaysWidget({Key key, this.vm}) : super(key: key);
  @override
  _DaysWidgetState createState() => _DaysWidgetState();
}

class _DaysWidgetState extends State<DaysWidget> {
  final controller = AutoScrollController();

  bool _showScrollUp = false;
  bool _afterFirstFrame = false;

  List<int> _targets = [];
  List<int> _focused = [];
  Map<int, int> _dayStartIndices = {};
  Map<int, Homework> homeworkIndexes = {};

  void _updateShowScrollUp() {
    final newScrollUp = controller.offset > 250;
    if (_showScrollUp != newScrollUp) {
      setState(() {
        _showScrollUp = newScrollUp;
      });
    }
  }

  double _distanceToItem(int item) {
    final ctx = controller.tagMap[item]?.context;
    if (ctx != null) {
      final renderBox = ctx.findRenderObject() as RenderBox;
      final RenderAbstractViewport viewport =
          RenderAbstractViewport.of(renderBox);
      var offsetToReveal = viewport.getOffsetToReveal(renderBox, 0.5).offset;
      if (offsetToReveal < 0) offsetToReveal = 0;
      final currentOffset = controller.offset;
      return (offsetToReveal - currentOffset).abs();
    }
    return null;
  }

  void _updateReachedHomeworks() {
    for (final target in _targets.toList()) {
      final distance = _distanceToItem(target);
      if (distance != null && distance < 50) {
        _focused.add(target);
        _targets.remove(target);
        controller.highlight(
          target,
          highlightDuration: Duration(milliseconds: 500),
          cancelExistHighlights: false,
        );
        if (_targets.isEmpty) setState(() {});
      }
    }
    for (final focusedItem in _focused.toList()) {
      final distance = _distanceToItem(focusedItem);
      if (distance == null || distance > 50) {
        _focused.remove(focusedItem);
        widget.vm.markAsNotNewOrChangedCallback(homeworkIndexes[focusedItem]);
      }
    }
  }

  void update() {
    _updateShowScrollUp();
    _updateReachedHomeworks();
  }

  void updateValues() {
    _targets.clear();
    _focused.clear();
    var index = 0;
    var dayIndex = 0;
    for (var day in widget.vm.days) {
      index++;
      _dayStartIndices[dayIndex] = index;
      for (var hw in day.homework) {
        if (hw.isNew || hw.isChanged) {
          _targets.add(index);
        }
        homeworkIndexes[index] = hw;
        index++;
      }
      dayIndex++;
    }
  }

  @override
  void initState() {
    updateValues();
    controller.addListener(() {
      update();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      update();
      _afterFirstFrame = true;
      setState(() {});
    });
    super.initState();
  }

  @override
  void didUpdateWidget(DaysWidget oldWidget) {
    updateValues();
    update();

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        controller: controller,
        itemCount: widget.vm.days.length + 1,
        itemBuilder: (context, n) {
          if (n == 0) {
            return Stack(
              alignment: Alignment.center,
              children: [
                HomeworkFilterContainer(),
                Positioned(
                  top: 0,
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Row(
                    children: [
                      Expanded(
                        child: AbsorbPointer(child: Container()),
                      ),
                      Spacer(),
                    ],
                  ),
                ),
                Center(
                  child: RaisedButton(
                    child: Text(
                      widget.vm.future ? "Vergangenheit" : "Zukunft",
                    ),
                    onPressed: widget.vm.onSwitchFuture,
                  ),
                ),
              ],
            );
          }
          if (n == widget.vm.days.length) {
            return SizedBox(
              height: 160,
            );
          }
          if (!widget.vm.future) {
            n = widget.vm.days.length + 1 - n;
          }
          return DayWidget(
            day: widget.vm.days[n - 1],
            vm: widget.vm,
            controller: controller,
            index: _dayStartIndices[n - 1],
          );
        },
      ),
      floatingActionButton: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          if (_showScrollUp)
            FloatingActionButton(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              heroTag: null,
              onPressed: () {
                controller.animateTo(
                  0,
                  duration: Duration(milliseconds: 500),
                  curve: Curves.decelerate,
                );
              },
              child: Icon(
                Icons.arrow_drop_up,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
              ),
              mini: true,
            ),
          if (_targets.isNotEmpty || _focused.isNotEmpty)
            FloatingActionButton(
              backgroundColor: Colors.red,
              heroTag: null,
              onPressed: () {
                widget.vm.markAllAsNotNewOrChangedCallback();
              },
              child: Icon(Icons.close),
              mini: true,
            ),
          if (_targets.isNotEmpty && _afterFirstFrame)
            FloatingActionButton.extended(
              backgroundColor: Colors.red,
              icon: Icon(Icons.arrow_drop_down),
              label: Text("Neue Einträge"),
              onPressed: () async {
                await controller.scrollToIndex(
                  _targets.first,
                  preferPosition: AutoScrollPosition.middle,
                );
              },
            ),
        ],
      ),
    );
  }
}

class DayWidget extends StatelessWidget {
  final DaysViewModel vm;
  final Day day;

  final AutoScrollController controller;
  final int index;

  const DayWidget({Key key, this.day, this.vm, this.controller, this.index})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    var i = index;
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  day.displayName,
                  style: Theme.of(context).textTheme.title,
                ),
              ),
            ),
            Spacer(),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () async {
                final message = await showDialog(
                    context: context,
                    builder: (context) {
                      String message = "";
                      return StatefulBuilder(
                        builder: (context, setState) => AlertDialog(
                          title: Text("Erinnerung"),
                          content: TextField(
                            maxLines: null,
                            onChanged: (msg) {
                              setState(() => message = msg);
                            },
                            decoration:
                                InputDecoration(hintText: 'zB. Hausaufgabe'),
                          ),
                          actions: <Widget>[
                            FlatButton(
                              child: Text("Abbrechen"),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            RaisedButton(
                              textTheme: ButtonTextTheme.primary,
                              child: Text(
                                "Speichern",
                              ),
                              onPressed: isNullOrEmpty(message)
                                  ? null
                                  : () {
                                      Navigator.pop(context, message);
                                    },
                            ),
                          ],
                        ),
                      );
                    });
                if (message != null) {
                  vm.addReminderCallback(day, message);
                }
              },
              padding: EdgeInsets.only(
                right: 15,
              ),
            ),
          ],
        ),
        for (final hw in day.homework)
          ItemWidget(
            item: hw,
            toggleDone: () => vm.toggleDoneCallback(hw, !hw.checked),
            removeThis: () => vm.removeReminderCallback(hw, day),
            setDoNotAskWhenDelete: vm.setDoNotWhenDeleteCallback,
            askWhenDelete: vm.askWhenDelete,
            controller: controller,
            index: i++,
          ),
        Divider(),
      ],
    );
  }
}

class ItemWidget extends StatelessWidget {
  final Homework item;
  final VoidCallback removeThis;
  final VoidCallback toggleDone;
  final VoidCallback setDoNotAskWhenDelete;
  final bool askWhenDelete, isHistory;

  final AutoScrollController controller;
  final int index;

  const ItemWidget(
      {Key key,
      this.item,
      this.removeThis,
      this.toggleDone,
      this.askWhenDelete,
      this.setDoNotAskWhenDelete,
      this.isHistory = false,
      this.controller,
      this.index})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    Widget child = Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: item.warning
            ? BorderSide(color: Colors.red, width: 1)
            : item.type == HomeworkType.grade || item.checked
                ? BorderSide(color: Colors.green, width: 0)
                : BorderSide(color: Colors.grey, width: 0),
        borderRadius: BorderRadius.circular(16),
      ),
      color: Colors.transparent,
      child: GestureDetector(
        onDoubleTap: !isHistory && item.checkable ? toggleDone : null,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        if (item.label != null)
                          Stack(
                            overflow: Overflow.visible,
                            children: <Widget>[
                              Center(
                                child: Text(
                                  item.label,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (item.isNew || item.isChanged)
                                Positioned(
                                  right: 0,
                                  child: item.isNew
                                      ? NewsSticker(
                                          text: "neu",
                                        )
                                      : NewsSticker(
                                          text: "geändert",
                                        ),
                                )
                            ],
                          ),
                        ListTile(
                          contentPadding: EdgeInsets.only(),
                          title: Text(item.title),
                          subtitle: isNullOrEmpty(item.subtitle)
                              ? null
                              : Text(item.subtitle),
                          leading: !isHistory && item.deleteable
                              ? IconButton(
                                  icon: Icon(Icons.close),
                                  onPressed: () async {
                                    if (askWhenDelete) {
                                      var ask = true;
                                      final delete = await showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              content: StatefulBuilder(
                                                builder: (context, setState) =>
                                                    SwitchListTile(
                                                  title: Text("Nie fragen"),
                                                  onChanged: (bool value) {
                                                    setState(
                                                        () => ask = !value);
                                                  },
                                                  value: !ask,
                                                ),
                                              ),
                                              title:
                                                  Text("Erinnerung löschen?"),
                                              actions: <Widget>[
                                                FlatButton(
                                                  child: Text("Abbrechen"),
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                ),
                                                RaisedButton(
                                                  textTheme:
                                                      ButtonTextTheme.primary,
                                                  child: Text(
                                                    "Löschen",
                                                  ),
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          context, true),
                                                )
                                              ],
                                            );
                                          });
                                      if (delete == true) {
                                        if (!ask) setDoNotAskWhenDelete();
                                        removeThis();
                                      }
                                    } else {
                                      removeThis();
                                    }
                                  },
                                  padding: EdgeInsets.all(0),
                                )
                              : null,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      if (!isHistory && item.label != null)
                        IconButton(
                          icon: Icon(
                            Icons.info_outline,
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (_context) {
                                return ListViewCapableAlertDialog(
                                  title: Text(item.title),
                                  content: ListView(
                                    shrinkWrap: true,
                                    children: <Widget>[
                                      Text(formatChanged(item)),
                                      if (item.previousVersion != null)
                                        ExpansionTile(
                                          title: Text("Versionen"),
                                          children: <Widget>[
                                            ItemWidget(
                                              item: item,
                                              isHistory: true,
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                  actions: <Widget>[
                                    RaisedButton(
                                      textTheme: ButtonTextTheme.primary,
                                      onPressed: () => Navigator.pop(_context),
                                      child: Text(
                                        "Ok",
                                      ),
                                    )
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      if (item.warning)
                        Text(
                          "!",
                          style: TextStyle(
                            color: Colors.red.shade900,
                            fontSize: 30,
                          ),
                        )
                      else if (item.type == HomeworkType.grade)
                        Text(
                          item.gradeFormatted,
                          style: TextStyle(color: Colors.green, fontSize: 30),
                        )
                      else if (!isHistory && item.checkable)
                        Checkbox(
                          activeColor: Colors.green,
                          value: item.checked,
                          onChanged: (done) {
                            toggleDone();
                          },
                        ),
                    ],
                  ),
                ],
              ),
              if (isHistory) ...[
                Divider(),
                Text(
                  formatChanged(item),
                  style: Theme.of(context).textTheme.caption,
                ),
              ]
            ],
          ),
        ),
      ),
    );
    if (!isHistory) {
      child = AutoScrollTag(
        index: index,
        key: ValueKey(index),
        controller: controller,
        child: child,
        highlightColor: Colors.grey.withOpacity(0.5),
      );
    }
    return Column(
      children: <Widget>[
        child,
        if (isHistory && item.previousVersion != null)
          ItemWidget(
            isHistory: true,
            item: item.previousVersion,
          ),
      ],
    );
  }
}

String formatChanged(Homework hw) {
  String date;
  if (hw.lastNotSeen == null) {
    date =
        "Vor ${DateFormat("EEEE, dd.MM, HH:mm,", "de").format(hw.firstSeen)} ";
  } else if (toDate(hw.firstSeen) == toDate(hw.lastNotSeen)) {
    date = "Am ${DateFormat("EEEE, dd.MM,", "de").format(hw.firstSeen)}"
        " zwischen ${DateFormat("HH:mm", "de").format(hw.lastNotSeen)} und ${DateFormat("HH:mm", "de").format(hw.firstSeen)}";
  } else {
    date =
        "Zwischen ${DateFormat("EEEE, dd.MM, HH:mm,", "de").format(hw.lastNotSeen)} "
        "und ${DateFormat("EEEE, dd.MM, HH:mm,", "de").format(hw.firstSeen)}";
  }
  if (hw.deleted) {
    return "$date gelöscht.";
  } else if (hw.previousVersion == null) {
    return "$date eingetragen.";
  } else if (hw.previousVersion.deleted) {
    return "$date wiederhergestellt.";
  } else {
    return "$date geändert.";
  }
}

DateTime toDate(DateTime dateTime) {
  return DateTime(dateTime.year, dateTime.month, dateTime.day);
}
