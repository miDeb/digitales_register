import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:redux/redux.dart';

import '../actions.dart';
import '../app_state.dart';
import '../data.dart';
import '../util.dart';

class DaysWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      builder: (context, vm) {
        return ListView.builder(
          itemCount: vm.days.length,
          itemBuilder: (context, n) {
            if (n == 0) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: RaisedButton(
                    child: Text(
                      vm.future ? "Vergangenheit" : "Zukunft",
                    ),
                    onPressed: vm.onSwitchFuture,
                  ),
                ),
              );
            }
            if (!vm.future) {
              n = vm.days.length + 1 - n;
            }
            return DayWidget(day: vm.days[n - 1], vm: vm);
          },
        );
      },
      converter: (store) {
        return _ViewModel.from(store);
      },
    );
  }
}

class DayWidget extends StatelessWidget {
  final _ViewModel vm;
  final Day day;

  const DayWidget({Key key, this.day, this.vm}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: .6,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.grey, width: 0.2),
          borderRadius: BorderRadius.circular(16),
        ),
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
                                                  Navigator.pop(
                                                      context, message);
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
              ] +
              day.homework
                  .map((h) => ItemWidget(
                        item: h,
                        toggleDone: () => vm.toggleDoneCallback(h, !h.checked),
                        removeThis: () => vm.removeReminderCallback(h, day),
                        setDoNotAskWhenDelete: vm.setDoNotWhenDeleteCallback,
                        askWhenDelete: vm.askWhenDelete,
                        doubleTapForDone: vm.doubleTapForDone,
                      ))
                  .toList() +
              (day.homework.isEmpty
                  ? [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Noch keine Aufgaben",
                          style: Theme.of(context).textTheme.subhead,
                        ),
                      ),
                    ]
                  : []),
        ));
  }
}

typedef void AddReminderCallback(Day day, String reminder);
typedef void RemoveReminderCallback(Homework hw, Day day);
typedef void ToggleDoneCallback(Homework hw, bool done);

class _ViewModel {
  final List<Day> days;
  final VoidCallback onSwitchFuture;
  final bool future;
  final bool askWhenDelete;
  final bool doubleTapForDone;
  final AddReminderCallback addReminderCallback;
  final RemoveReminderCallback removeReminderCallback;
  final ToggleDoneCallback toggleDoneCallback;
  final VoidCallback setDoNotWhenDeleteCallback;
  _ViewModel.from(Store<AppState> store)
      : days = store.state.dayState.displayDays.toList(),
        onSwitchFuture = (() => store.dispatch(SwitchFutureAction())),
        future = store.state.dayState.future,
        doubleTapForDone = store.state.settingsState.doubleTapForDone,
        addReminderCallback =
            ((day, msg) => store.dispatch(AddReminderAction(msg, day.date))),
        removeReminderCallback =
            ((hw, day) => store.dispatch(DeleteHomeworkAction(hw, day.date))),
        toggleDoneCallback =
            ((hw, done) => store.dispatch(ToggleDoneAction(hw, done))),
        askWhenDelete = store.state.settingsState.askWhenDelete,
        setDoNotWhenDeleteCallback =
            (() => store.dispatch(SetAskWhenDeleteAction(false)));
}

class ItemWidget extends StatelessWidget {
  final Homework item;
  final VoidCallback removeThis;
  final VoidCallback toggleDone;
  final VoidCallback setDoNotAskWhenDelete;
  final bool askWhenDelete, doubleTapForDone;

  const ItemWidget(
      {Key key,
      this.item,
      this.removeThis,
      this.toggleDone,
      this.askWhenDelete,
      this.setDoNotAskWhenDelete,
      this.doubleTapForDone})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: .6,
      shape: RoundedRectangleBorder(
        side: item.warning
            ? BorderSide(color: Colors.red, width: 2)
            : item.type == HomeworkType.grade || item.checked
                ? BorderSide(color: Colors.green, width: 2)
                : BorderSide(color: Colors.grey, width: .2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: GestureDetector(
        onDoubleTap: doubleTapForDone && item.checkable ? toggleDone : null,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              item.label != null
                  ? Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              Text(
                                item.label,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Row(
                                children: <Widget>[
                                  Spacer(),
                                  Flexible(
                                    child: Divider(
                                        //height: 0,
                                        ),
                                    flex: 9,
                                  ),
                                  Spacer(),
                                ],
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.info_outline,
                          ),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (_context) {
                                  return AlertDialog(
                                    title: Text(item.title),
                                    content: ListView(
                                      shrinkWrap: true,
                                      children: <Widget>[
                                        Text(formatChanged(item)),
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
                leading: item.deleteable
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
                        : item.checkable && !doubleTapForDone
                            ? Checkbox(
                                activeColor: Colors.green,
                                value: item.checked,
                                onChanged: (done) {
                                  toggleDone();
                                },
                              )
                            : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String formatChanged(Homework hw) {
  String date;
  if (hw.lastNotSeen == null) {
    date =
        "Vor ${DateFormat("EEEE, dd.MM., HH:mm,", "de").format(hw.firstSeen)} ";
  } else if (toDate(hw.firstSeen) == toDate(hw.lastNotSeen)) {
    date = "Am ${DateFormat("EEEE, dd.MM.,", "de").format(hw.firstSeen)}"
        " zwischen ${DateFormat("HH:mm", "de").format(hw.lastNotSeen)} und ${DateFormat("HH:mm", "de").format(hw.firstSeen)}";
  } else {
    date =
        "Zwischen ${DateFormat("EEEE, dd.MM., HH:mm,", "de").format(hw.lastNotSeen)} "
        "und ${DateFormat("EEEE, dd.MM., HH:mm,", "de").format(hw.firstSeen)}";
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
