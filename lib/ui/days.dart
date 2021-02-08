import 'package:badges/badges.dart';
import 'package:deleteable_tile/deleteable_tile.dart';
import 'package:dr/container/notification_icon_container.dart';
import 'package:dr/container/sidebar_container.dart';
import 'package:dr/main.dart';
import 'package:dr/middleware/middleware.dart';

import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:responsive_scaffold/responsive_scaffold.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:tuple/tuple.dart';
import 'package:built_collection/built_collection.dart';

import '../app_state.dart';
import '../container/days_container.dart';
import '../container/homework_filter_container.dart';
import '../data.dart';
import '../util.dart';
import 'dialog.dart';
import 'no_internet.dart';

typedef AddReminderCallback = void Function(Day day, String reminder);
typedef RemoveReminderCallback = void Function(Homework hw, Day day);
typedef ToggleDoneCallback = void Function(Homework hw, bool done);
typedef MarkAsNotNewOrChangedCallback = void Function(Homework hw);
typedef MarkDeletedHomeworkAsSeenCallback = void Function(Day day);

class DaysWidget extends StatefulWidget {
  final DaysViewModel vm;

  final MarkAsNotNewOrChangedCallback markAsSeenCallback;
  final MarkDeletedHomeworkAsSeenCallback markDeletedHomeworkAsSeenCallback;
  final VoidCallback markAllAsSeenCallback;
  final AddReminderCallback addReminderCallback;
  final RemoveReminderCallback removeReminderCallback;
  final VoidCallback onSwitchFuture;
  final ToggleDoneCallback toggleDoneCallback;
  final VoidCallback setDoNotAskWhenDeleteCallback;
  final VoidCallback refresh;
  final VoidCallback refreshNoInternet;
  final AttachmentCallback onDownloadAttachment, onOpenAttachment;

  const DaysWidget({
    Key key,
    this.vm,
    this.markAsSeenCallback,
    this.markDeletedHomeworkAsSeenCallback,
    this.addReminderCallback,
    this.removeReminderCallback,
    this.markAllAsSeenCallback,
    this.onSwitchFuture,
    this.toggleDoneCallback,
    this.setDoNotAskWhenDeleteCallback,
    this.refresh,
    this.refreshNoInternet,
    this.onDownloadAttachment,
    this.onOpenAttachment,
  }) : super(key: key);
  @override
  _DaysWidgetState createState() => _DaysWidgetState();
}

class _DaysWidgetState extends State<DaysWidget> {
  final controller = AutoScrollController();

  bool _showScrollUp = false;
  bool _afterFirstFrame = false;

  final List<int> _targets = [];
  final List<int> _focused = [];
  final Map<int, int> _dayStartIndices = {};
  final Map<int, Homework> _homeworkIndexes = {};
  final Map<int, Day> _dayIndexes = {};

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
          highlightDuration: const Duration(milliseconds: 500),
          cancelExistHighlights: false,
        );
        if (_targets.isEmpty) setState(() {});
      }
    }
    for (final focusedItem in _focused.toList()) {
      final distance = _distanceToItem(focusedItem);
      if (distance == null || distance > 50) {
        _focused.remove(focusedItem);
        if (_dayIndexes.containsKey(focusedItem)) {
          widget.markDeletedHomeworkAsSeenCallback(_dayIndexes[focusedItem]);
        } else if (_homeworkIndexes.containsKey(focusedItem)) {
          widget.markAsSeenCallback(_homeworkIndexes[focusedItem]);
        } else {
          assert(
            false,
            "A target index should either be a new/changed homework or a day (deleted homework)",
          );
        }
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
    for (final day in widget.vm.days) {
      _dayStartIndices[dayIndex] = index;
      if (day.deletedHomework.any((h) => h.isChanged)) {
        _targets.add(index);
        _dayIndexes[index] = day;
      }
      index++;
      for (final hw in day.homework) {
        if (hw.isNew || hw.isChanged) {
          _targets.add(index);
        }
        _homeworkIndexes[index] = hw;
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

  Widget getItem(int n, {@required bool noEntries, @required bool noInternet}) {
    if (n == 0) {
      return Stack(
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
                const SizedBox(
                  width: 60,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Center(
              child: ElevatedButton(
                onPressed: widget.onSwitchFuture,
                child: Text(
                  widget.vm.future ? "Vergangenheit" : "Zukunft",
                ),
              ),
            ),
          ),
        ],
      );
    }
    if (n == widget.vm.days.length + 1) {
      if (noEntries) {
        if (noInternet) {
          return Column(
            children: const [
              SizedBox(
                height: 120,
              ),
              NoInternet(),
            ],
          );
        } else {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Text(
                "Keine Einträge vorhanden",
                style: Theme.of(context).textTheme.headline4,
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
      } else {
        return const SizedBox(
          height: 160,
        );
      }
    }
    return DayWidget(
      day: widget.vm.days[n - 1],
      vm: widget.vm,
      controller: controller,
      index: _dayStartIndices[n - 1],
      addReminderCallback: widget.addReminderCallback,
      removeReminderCallback: widget.removeReminderCallback,
      toggleDoneCallback: widget.toggleDoneCallback,
      setDoNotAskWhenDeleteCallback: widget.setDoNotAskWhenDeleteCallback,
      onDownloadAttachment: widget.onDownloadAttachment,
      onOpenAttachment: widget.onOpenAttachment,
      colorBorders: widget.vm.colorBorders,
      colorTestsInRed: widget.vm.colorTestsInRed,
      subjectThemes: widget.vm.subjectThemes,
    );
  }

  @override
  Widget build(BuildContext context) {
    final noInternet = widget.vm.noInternet;
    final noEntries = widget.vm.days.isEmpty;
    Widget body = ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      controller: controller,
      itemCount: widget.vm.days.length + 2,
      itemBuilder: (context, n) {
        return getItem(n, noEntries: noEntries, noInternet: noInternet);
      },
    );
    if (!noInternet) {
      body = RefreshIndicator(
        onRefresh: () async => widget.refresh(),
        child: body,
      );
    }
    if (widget.vm.loading) {
      body = Stack(
        children: [
          body,
          const LinearProgressIndicator(),
        ],
      );
    }
    return ResponsiveScaffold<Pages>(
      key: scaffoldKey,
      homeBody: body,
      homeFloatingActionButton: Column(
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
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.decelerate,
                );
              },
              mini: true,
              child: Icon(
                Icons.arrow_drop_up,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
              ),
            ),
          if (_targets.isNotEmpty || _focused.isNotEmpty)
            FloatingActionButton(
              backgroundColor: Colors.red,
              heroTag: null,
              onPressed: () {
                widget.markAllAsSeenCallback();
              },
              mini: true,
              child: const Icon(Icons.close),
            ),
          if (_targets.isNotEmpty && _afterFirstFrame)
            FloatingActionButton.extended(
              backgroundColor: Colors.red,
              icon: const Icon(Icons.arrow_drop_down),
              label: const Text("Neue Einträge"),
              onPressed: () async {
                await controller.scrollToIndex(
                  _targets.first,
                  preferPosition: AutoScrollPosition.middle,
                );
              },
            ),
        ],
      ),
      homeAppBar: ResponsiveAppBar(
        title: const Text("Register"),
        actions: <Widget>[
          if (widget.vm.noInternet)
            TextButton(
              style: TextButton.styleFrom(
                primary: Theme.of(context).colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              onPressed: widget.refreshNoInternet,
              child: Row(
                children: const [
                  Text("Keine Verbindung"),
                  SizedBox(width: 8),
                  Icon(Icons.refresh),
                ],
              ),
            ),
          if (widget.vm.showNotifications) NotificationIconContainer(),
        ],
      ),
      drawerBuilder: (_widgetSelected, goHome, currentSelected, tabletMode) {
        // _widgetSelected is not passed down because routing is done by
        // accessing the ResponsiveScaffoldState via the GlobalKey and calling
        // selectContentWidget on it.
        return SidebarContainer(
          currentSelected: currentSelected,
          goHome: goHome,
          tabletMode: tabletMode,
        );
      },
      homeId: Pages.homework,
      navKey: nestedNavKey,
    );
  }
}

class DayWidget extends StatelessWidget {
  final DaysViewModel vm;

  final AddReminderCallback addReminderCallback;
  final RemoveReminderCallback removeReminderCallback;
  final ToggleDoneCallback toggleDoneCallback;
  final VoidCallback setDoNotAskWhenDeleteCallback;
  final AttachmentCallback onDownloadAttachment, onOpenAttachment;
  final bool colorBorders, colorTestsInRed;
  final BuiltMap<String, SubjectTheme> subjectThemes;

  final Day day;

  final AutoScrollController controller;
  final int index;

  const DayWidget({
    Key key,
    this.day,
    this.vm,
    this.controller,
    this.index,
    this.addReminderCallback,
    this.removeReminderCallback,
    this.toggleDoneCallback,
    this.setDoNotAskWhenDeleteCallback,
    this.onDownloadAttachment,
    this.onOpenAttachment,
    @required this.colorBorders,
    @required this.subjectThemes,
    @required this.colorTestsInRed,
  }) : super(key: key);

  Future<String> showEnterReminderDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        String message = "";
        return StatefulBuilder(
          builder: (context, setState) => InfoDialog(
            title: const Text("Erinnerung"),
            content: TextField(
              maxLines: null,
              onChanged: (msg) {
                setState(() => message = msg);
              },
              decoration: const InputDecoration(hintText: 'zB. Hausaufgabe'),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Abbrechen"),
              ),
              ElevatedButton(
                onPressed: message.isNullOrEmpty
                    ? null
                    : () {
                        Navigator.pop(context, message);
                      },
                child: const Text(
                  "Speichern",
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var i = index;
    return Column(
      children: <Widget>[
        SizedBox(
          height: 48,
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    day.displayName,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
              ),
              if (day.deletedHomework.isNotEmpty)
                AutoScrollTag(
                  controller: controller,
                  index: index,
                  key: ValueKey(index),
                  highlightColor: Colors.grey.withOpacity(0.5),
                  child: IconButton(
                    icon: Badge(
                      badgeContent: Icon(
                        Icons.delete,
                        size: 15,
                        color: day.deletedHomework.any((h) => h.isChanged)
                            ? Colors.white
                            : null,
                      ),
                      badgeColor: day.deletedHomework.any((h) => h.isChanged)
                          ? Colors.red
                          : Theme.of(context).scaffoldBackgroundColor,
                      toAnimate: day.deletedHomework.any((h) => h.isChanged),
                      padding: EdgeInsets.zero,
                      position: BadgePosition.topStart(),
                      elevation: 0,
                      child: const Icon(Icons.info_outline),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_context) {
                          return InfoDialog(
                            title: const Text("Gelöschte Einträge"),
                            content: ListView(
                              shrinkWrap: true,
                              children: day.deletedHomework
                                  .map(
                                    (i) => ItemWidget(
                                      item: i,
                                      isDeletedView: true,
                                      colorBorder: colorBorders,
                                      subjectThemes: subjectThemes,
                                      colorTestsInRed: colorTestsInRed,
                                    ),
                                  )
                                  .toList(),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              const Spacer(),
              if (vm.showAddReminder)
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: vm.noInternet
                      ? null
                      : () async {
                          final message =
                              await showEnterReminderDialog(context);
                          if (message != null) {
                            addReminderCallback(day, message);
                          }
                        },
                ),
            ],
          ),
        ),
        for (final hw in day.homework)
          ItemWidget(
            item: hw,
            toggleDone: () => toggleDoneCallback(hw, !hw.checked),
            removeThis: () => removeReminderCallback(hw, day),
            setDoNotAskWhenDelete: setDoNotAskWhenDeleteCallback,
            askWhenDelete: vm.askWhenDelete,
            noInternet: vm.noInternet,
            controller: controller,
            index: ++i,
            onDownloadAttachment: onDownloadAttachment,
            onOpenAttachment: onOpenAttachment,
            subjectThemes: subjectThemes,
            colorBorder: colorBorders,
            colorTestsInRed: colorTestsInRed,
          ),
        const Divider(),
      ],
    );
  }
}

class ItemWidget extends StatelessWidget {
  final Homework item;
  final VoidCallback removeThis;
  final VoidCallback toggleDone;
  final VoidCallback setDoNotAskWhenDelete;
  final bool askWhenDelete,
      isHistory,
      isDeletedView,
      noInternet,
      isCurrent,
      colorBorder,
      colorTestsInRed;
  final AttachmentCallback onDownloadAttachment, onOpenAttachment;
  final BuiltMap<String, SubjectTheme> subjectThemes;

  final AutoScrollController controller;
  final int index;

  const ItemWidget({
    Key key,
    @required this.item,
    this.removeThis,
    this.toggleDone,
    this.askWhenDelete,
    this.setDoNotAskWhenDelete,
    this.isHistory = false,
    this.controller,
    this.index,
    this.isDeletedView = false,
    this.noInternet,
    this.isCurrent = true,
    this.onDownloadAttachment,
    this.onOpenAttachment,
    @required this.colorBorder,
    @required this.subjectThemes,
    @required this.colorTestsInRed,
  }) : super(key: key);

  Future<Tuple2<bool, bool>> _showConfirmDelete(BuildContext context) async {
    var ask = true;
    final delete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return InfoDialog(
          content: StatefulBuilder(
            builder: (context, setState) => SwitchListTile.adaptive(
              title: const Text("Nie fragen"),
              onChanged: (bool value) {
                setState(() => ask = !value);
              },
              value: !ask,
            ),
          ),
          title: const Text("Erinnerung löschen?"),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Abbrechen"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text(
                "Löschen",
              ),
            )
          ],
        );
      },
    );
    return Tuple2(delete, ask);
  }

  void _showHistory(BuildContext context) {
    // if we are in the deleted view, show the history for the previous item
    final historyItem = isDeletedView ? item.previousVersion : item;
    showDialog(
      context: context,
      builder: (_context) {
        return InfoDialog(
          title: Text(historyItem.title),
          content: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Text(formatChanged(historyItem)),
              if (historyItem.previousVersion != null)
                ExpansionTile(
                  title: const Text("Versionen"),
                  children: <Widget>[
                    ItemWidget(
                      item: historyItem,
                      isHistory: true,
                      colorBorder: colorBorder,
                      subjectThemes: subjectThemes,
                      colorTestsInRed: colorTestsInRed,
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }

  Tuple2<Color, double> _getBorderConfig() {
    if (item.warning && colorTestsInRed) {
      return const Tuple2(Colors.red, 1.5);
    }
    if (colorBorder && subjectThemes.containsKey(item.label)) {
      return Tuple2(Color(subjectThemes[item.label].color), 1.5);
    }
    if (item.type == HomeworkType.grade || item.checked) {
      return const Tuple2(Colors.green, 0);
    }
    return const Tuple2(Colors.grey, 0);
  }

  @override
  Widget build(BuildContext context) {
    Widget child = Deleteable(
      showEntryAnimation: item.lastNotSeen != null &&
          DateTime.now().difference(item.lastNotSeen) <
              const Duration(seconds: 1),
      builder: (context, delete) => Card(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: _getBorderConfig().item1,
            width: _getBorderConfig().item2,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 8,
                        top: 8,
                        bottom: 6,
                      ),
                      child: Column(
                        children: <Widget>[
                          if (item.label != null)
                            Stack(
                              clipBehavior: Clip.none,
                              children: <Widget>[
                                Center(
                                  child: Text(
                                    item.label,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if ((!isHistory &&
                                        (item.isNew || item.isChanged)) ||
                                    (isHistory && isCurrent))
                                  Positioned(
                                    right: 0,
                                    child: Badge(
                                      shape: BadgeShape.square,
                                      borderRadius: BorderRadius.circular(20),
                                      badgeContent: Text(
                                        isHistory && isCurrent
                                            ? "aktuell"
                                            : item.isNew
                                                ? "neu"
                                                : item.deleted
                                                    ? "gelöscht"
                                                    : "geändert",
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ),
                                  )
                              ],
                            ),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(item.title),
                            subtitle: item.subtitle.isNullOrEmpty
                                ? null
                                : SelectableText(item.subtitle),
                            leading:
                                !isHistory && !isDeletedView && item.deleteable
                                    ? IconButton(
                                        icon: const Icon(Icons.close),
                                        onPressed: noInternet
                                            ? null
                                            : () async {
                                                if (askWhenDelete) {
                                                  final confirmationResult =
                                                      await _showConfirmDelete(
                                                          context);
                                                  final shouldDelete =
                                                      confirmationResult.item1;
                                                  final ask =
                                                      confirmationResult.item2;
                                                  if (shouldDelete == true) {
                                                    if (!ask) {
                                                      setDoNotAskWhenDelete();
                                                    }
                                                    await delete();
                                                    removeThis();
                                                  }
                                                } else {
                                                  await delete();
                                                  removeThis();
                                                }
                                              },
                                        padding: const EdgeInsets.all(0),
                                      )
                                    : null,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      if (!isHistory && item.label != null)
                        IconButton(
                          icon: (isDeletedView
                                      ? item.previousVersion.previousVersion
                                      : item.previousVersion) !=
                                  null
                              ? Badge(
                                  badgeContent:
                                      const Icon(Icons.edit, size: 15),
                                  padding: EdgeInsets.zero,
                                  badgeColor: isDeletedView
                                      ? Theme.of(context).dialogBackgroundColor
                                      : Theme.of(context)
                                          .scaffoldBackgroundColor,
                                  toAnimate: false,
                                  elevation: 0,
                                  child: const Icon(
                                    Icons.info_outline,
                                  ),
                                )
                              : const Icon(
                                  Icons.info_outline,
                                ),
                          onPressed: () {
                            _showHistory(context);
                          },
                        ),
                      if (item.type == HomeworkType.grade)
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(
                            item.gradeFormatted,
                            style: const TextStyle(
                                color: Colors.green, fontSize: 30),
                          ),
                        )
                      else if (!isHistory && !isDeletedView && item.checkable)
                        Checkbox(
                          visualDensity: VisualDensity.standard,
                          activeColor: Colors.green,
                          value: item.checked,
                          onChanged: noInternet
                              ? null
                              : (done) {
                                  toggleDone();
                                },
                        ),
                    ],
                  ),
                ],
              ),
              if (isHistory || isDeletedView) ...[
                const Divider(height: 0),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    formatChanged(item),
                    style: Theme.of(context).textTheme.caption,
                  ),
                ),
              ],
              if (item.gradeGroupSubmissions?.isNotEmpty == true) ...[
                const Divider(),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Anhang",
                        style: Theme.of(context).textTheme.subtitle1),
                  ),
                ),
                for (final attachment in item.gradeGroupSubmissions)
                  AttachmentWidget(
                    ggs: attachment,
                    noInternet: noInternet,
                    downloadCallback: onDownloadAttachment,
                    openCallback: onOpenAttachment,
                  )
              ]
            ],
          ),
        ),
      ),
    );
    if (!isHistory && !isDeletedView) {
      child = AutoScrollTag(
        index: index,
        key: ValueKey(index),
        controller: controller,
        highlightColor: Colors.grey.withOpacity(0.5),
        child: child,
      );
    }
    return Column(
      key: ObjectKey(item),
      children: <Widget>[
        child,
        if (isHistory && item.previousVersion != null)
          ItemWidget(
            isHistory: true,
            isCurrent: false,
            item: item.previousVersion,
            colorBorder: colorBorder,
            subjectThemes: subjectThemes,
            colorTestsInRed: colorTestsInRed,
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

class AttachmentWidget extends StatelessWidget {
  final GradeGroupSubmission ggs;
  final AttachmentCallback downloadCallback;
  final AttachmentCallback openCallback;
  final bool noInternet;

  const AttachmentWidget(
      {Key key,
      this.ggs,
      this.downloadCallback,
      this.noInternet,
      this.openCallback})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const Divider(
            indent: 16,
            height: 0,
          ),
          ListTile(title: Text(ggs.originalName)),
          if (ggs.downloading) const LinearProgressIndicator(),
          if (!ggs.fileAvailable)
            TextButton(
              onPressed: noInternet
                  ? null
                  : () {
                      downloadCallback(ggs);
                    },
              child: const Text("Herunterladen"),
            )
          else
            IntrinsicHeight(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextButton(
                      onPressed: noInternet
                          ? null
                          : () {
                              downloadCallback(ggs);
                            },
                      child: const Text("Erneut herunterladen"),
                    ),
                  ),
                  const VerticalDivider(
                    indent: 8,
                    endIndent: 8,
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        openCallback(ggs);
                      },
                      child: const Text("Öffnen"),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
