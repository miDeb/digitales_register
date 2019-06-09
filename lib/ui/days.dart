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

  bool scrollDown = true;
  bool showScrollUp = false;
  int destination, next;
  double currentHomeworkOffset;
  Homework destinationHomework, currentHomework, nextHomework;
  Map<int, int> realIndices = {};

  void update() {
    final newScrollUp = controller.offset > 250;
    if (showScrollUp != newScrollUp) {
      setState(() {
        showScrollUp = newScrollUp;
      });
    }
    if (destination != null) {
      final ctx = controller.tagMap[destination]?.context;
      bool newScrollDirection;
      if (ctx == null && destination != null) {
        newScrollDirection = controller.tagMap.keys.first < destination;
      } else {
        final renderBox = ctx.findRenderObject() as RenderBox;
        final RenderAbstractViewport viewport =
            RenderAbstractViewport.of(renderBox);
        final revealedOffset =
            viewport.getOffsetToReveal(renderBox, 0.5).offset;
        final currentOffset = controller.offset;
        newScrollDirection = revealedOffset - currentOffset > 0;
        if ((revealedOffset == currentOffset ||
                scrollDown != newScrollDirection) &&
            currentHomework == null) {
          currentHomeworkOffset = currentOffset;
          currentHomework = destinationHomework;
          destinationHomework = nextHomework;
          controller.highlight(destination,
              highlightDuration: Duration(milliseconds: 500));
          destination = next;
          update();
        }
      }
      if (scrollDown != newScrollDirection) {
        setState(() {
          scrollDown = newScrollDirection;
        });
      }
    }
    if (currentHomeworkOffset != null &&
        (controller.offset - currentHomeworkOffset).abs() > 20) {
      widget.vm.markAsNotNewOrChangedCallback(currentHomework);
      currentHomework = currentHomeworkOffset = null;
    }
  }

  void updateValues() {
    var foundFirst = false, foundSecond = false, foundCurrentHomework = false;
    var index = 1;
    var dayIndex = 1;
    destination = destinationHomework = next = nextHomework = null;
    for (var day in widget.vm.days) {
      realIndices[dayIndex] = index;
      for (var hw in day.homework) {
        if (hw.isNew || hw.isChanged) {
          if (hw == currentHomework) {
            foundCurrentHomework = true;
          }
          if (!foundFirst && hw != currentHomework) {
            destination = index;
            destinationHomework = hw;
            foundFirst = true;
          } else if (!foundSecond) {
            next = index;
            nextHomework = hw;
            foundSecond = true;
          }
        }
        index++;
      }
      dayIndex++;
    }
    if (!foundCurrentHomework) {
      currentHomework = currentHomeworkOffset = null;
    }
  }

  @override
  void initState() {
    updateValues();
    controller.addListener(() {
      update();
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
              children: [
                HomeworkFilterContainer(),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 2),
                    child: RaisedButton(
                      child: Text(
                        widget.vm.future ? "Vergangenheit" : "Zukunft",
                      ),
                      onPressed: widget.vm.onSwitchFuture,
                    ),
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
            index: realIndices[n],
          );
        },
      ),
      floatingActionButton: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          if (showScrollUp)
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
          if (currentHomework != null || destination != null)
            FloatingActionButton(
              backgroundColor: Colors.red,
              heroTag: null,
              onPressed: () {
                widget.vm.markAllAsNotNewOrChangedCallback();
              },
              child: Icon(Icons.close),
              mini: true,
            ),
          if (destination != null)
            FloatingActionButton.extended(
              backgroundColor: Colors.red,
              icon: Icon(
                  scrollDown ? Icons.arrow_drop_down : Icons.arrow_drop_up),
              label: Text("Neue Einträge"),
              onPressed: () async {
                await controller.scrollToIndex(destination,
                    preferPosition: AutoScrollPosition.middle);
                // controller.highlight(destination,
                //     highlightDuration: Duration(milliseconds: 500));
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
    return Card(
        elevation: .6,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.grey, width: 1),
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 8, left: 15),
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
                                    onChanged: (msg) {
                                      setState(() => message = msg);
                                    },
                                    decoration: InputDecoration(
                                        hintText: 'zB. Hausaufgabe'),
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
                    top: 8,
                    bottom: 8,
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
                doubleTapForDone: vm.doubleTapForDone,
                controller: controller,
                index: i++,
              ),
            if (day.homework.isEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Nichts eingetragen",
                  style: Theme.of(context).textTheme.subhead,
                ),
              ),
          ],
        ));
  }
}

class ItemWidget extends StatelessWidget {
  final Homework item;
  final VoidCallback removeThis;
  final VoidCallback toggleDone;
  final VoidCallback setDoNotAskWhenDelete;
  final bool askWhenDelete, doubleTapForDone, isHistory;

  final AutoScrollController controller;
  final int index;

  const ItemWidget(
      {Key key,
      this.item,
      this.removeThis,
      this.toggleDone,
      this.askWhenDelete,
      this.setDoNotAskWhenDelete,
      this.doubleTapForDone,
      this.isHistory = false,
      this.controller,
      this.index})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    Widget child = Card(
      elevation: .6,
      shape: RoundedRectangleBorder(
        side: item.warning
            ? BorderSide(color: Colors.red, width: 2)
            : item.type == HomeworkType.grade || item.checked
                ? BorderSide(color: Colors.green, width: 2)
                : BorderSide(color: Colors.grey, width: 1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: GestureDetector(
        onDoubleTap: !isHistory && doubleTapForDone && item.checkable
            ? toggleDone
            : null,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              item.label != null
                  ? Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      item.label,
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if (item.isNew || item.isChanged)
                                    SizedBox(
                                      width: 16,
                                    ),
                                  if (item.isNew)
                                    NewsSticker(
                                      text: "neu",
                                    ),
                                  if (item.isChanged)
                                    NewsSticker(
                                      text: "geändert",
                                    ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Spacer(),
                                  Flexible(
                                    child: Divider(),
                                    flex: 9,
                                  ),
                                  Spacer(),
                                ],
                              ),
                            ],
                          ),
                        ),
                        if (!isHistory)
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
                                          onPressed: () =>
                                              Navigator.pop(_context),
                                          child: Text(
                                            "Ok",
                                          ),
                                        )
                                      ],
                                    );
                                  });
                            },
                          ),
                      ],
                    )
                  : Container(),
              ListTile(
                contentPadding: EdgeInsets.only(),
                title: Text(item.title),
                subtitle:
                    isNullOrEmpty(item.subtitle) ? null : Text(item.subtitle),
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
                                              setState(() => ask = !value);
                                            },
                                            value: !ask,
                                          ),
                                    ),
                                    title: Text("Erinnerung löschen?"),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text("Abbrechen"),
                                        onPressed: () => Navigator.pop(context),
                                      ),
                                      RaisedButton(
                                        textTheme: ButtonTextTheme.primary,
                                        child: Text(
                                          "Löschen",
                                        ),
                                        onPressed: () =>
                                            Navigator.pop(context, true),
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
                trailing: item.warning
                    ? Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Text(
                          "!",
                          style: TextStyle(
                            color: Colors.red.shade900,
                            fontSize: 30,
                          ),
                        ),
                      )
                    : item.type == HomeworkType.grade
                        ? Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Text(
                              item.gradeFormatted,
                              style:
                                  TextStyle(color: Colors.green, fontSize: 30),
                            ),
                          )
                        : !isHistory && item.checkable && !doubleTapForDone
                            ? Checkbox(
                                activeColor: Colors.green,
                                value: item.checked,
                                onChanged: (done) {
                                  toggleDone();
                                },
                              )
                            : null,
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
        highlightColor: Colors.grey,
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
