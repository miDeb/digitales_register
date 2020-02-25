import 'dart:io';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../container/settings_page.dart';
import 'network_protocol_page.dart';

class SettingsPageWidget extends StatefulWidget {
  final OnSettingChanged<bool> onSetNoPassSaving;
  final OnSettingChanged<bool> onSetNoDataSaving;
  final OnSettingChanged<bool> onSetAskWhenDelete;
  final OnSettingChanged<bool> onSetDeleteDataOnLogout;
  final OnSettingChanged<bool> onSetOfflineEnabled;
  final OnSettingChanged<bool> onSetShowCalendarEditNicksBar;
  final OnSettingChanged<bool> onSetShowGradesDiagram;
  final OnSettingChanged<bool> onSetShowAllSubjectsAverage;
  final OnSettingChanged<bool> onSetDashboardMarkNewOrChangedEntries;
  final OnSettingChanged<bool> onSetDarkMode;
  final OnSettingChanged<bool> onSetFollowDeviceDarkMode;
  final OnSettingChanged<bool> onSetPlatformOverride;
  final OnSettingChanged<Map<String, String>> onSetSubjectNicks;
  final VoidCallback onShowProfile;
  final SettingsViewModel vm;

  SettingsPageWidget({
    Key key,
    this.onSetNoPassSaving,
    this.onSetNoDataSaving,
    this.onSetAskWhenDelete,
    this.onSetDeleteDataOnLogout,
    this.onSetOfflineEnabled,
    this.onSetShowCalendarEditNicksBar,
    this.onSetShowGradesDiagram,
    this.onSetShowAllSubjectsAverage,
    this.onSetDashboardMarkNewOrChangedEntries,
    this.onSetDarkMode,
    this.onSetSubjectNicks,
    this.vm,
    this.onSetPlatformOverride,
    this.onSetFollowDeviceDarkMode,
    this.onShowProfile,
  }) : super(key: key);

  @override
  _SettingsPageWidgetState createState() => _SettingsPageWidgetState();
}

class _SettingsPageWidgetState extends State<SettingsPageWidget> {
  final controller = AutoScrollController();

  @override
  void initState() {
    if (widget.vm.showSubjectNicks) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        controller.scrollToIndex(4, preferPosition: AutoScrollPosition.begin);
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.vm.showSubjectNicks) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        controller.scrollToIndex(4, preferPosition: AutoScrollPosition.begin);
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Einstellungen"),
      ),
      body: ListView(
        controller: controller,
        children: <Widget>[
          SizedBox(height: 8),
          ListTile(
            title: Text(
              "Profil",
              style: Theme.of(context).textTheme.headline,
            ),
            trailing: Icon(Icons.chevron_right),
            onTap: widget.onShowProfile,
          ),
          Divider(),
          AutoScrollTag(
            child: ListTile(
              title: Text(
                "Anmeldung",
                style: Theme.of(context).textTheme.headline,
              ),
            ),
            controller: controller,
            index: 0,
            key: ObjectKey(0),
          ),
          SwitchListTile(
            title: Text("Angemeldet bleiben"),
            onChanged: (bool value) {
              widget.onSetNoPassSaving(!value);
            },
            value: !widget.vm.noPassSaving,
          ),
          SwitchListTile(
            title: Text("Daten lokal speichern"),
            subtitle: Text('Sehen, wann etwas eingetragen wurde'),
            onChanged: (bool value) {
              widget.onSetNoDataSaving(!value);
            },
            value: !widget.vm.noDataSaving,
          ),
          SwitchListTile(
            title: Text("Offline-Login"),
            onChanged: !widget.vm.noPassSaving && !widget.vm.noDataSaving
                ? (bool value) {
                    widget.onSetOfflineEnabled(value);
                  }
                : null,
            value: widget.vm.offlineEnabled,
          ),
          SwitchListTile(
            title: Text("Daten beim Ausloggen löschen"),
            onChanged: !widget.vm.noPassSaving && !widget.vm.noDataSaving
                ? (bool value) {
                    widget.onSetDeleteDataOnLogout(value);
                  }
                : null,
            value: widget.vm.deleteDataOnLogout,
          ),
          Divider(),
          if (!Platform.isLinux) ...[
            AutoScrollTag(
              child: ListTile(
                title: Text(
                  "Theme",
                  style: Theme.of(context).textTheme.headline,
                ),
              ),
              controller: controller,
              index: 1,
              key: ObjectKey(1),
            ),
            SwitchListTile(
              title: Text("Dark Mode"),
              onChanged: DynamicTheme.of(context).followDevice
                  ? null
                  : (bool value) {
                      widget.onSetDarkMode(value);
                    },
              value:
                  DynamicTheme.of(context).customBrightness == Brightness.dark,
            ),
            SwitchListTile(
              title: Text("Geräte-Theme folgen"),
              onChanged: (bool value) {
                widget.onSetFollowDeviceDarkMode(value);
              },
              value: DynamicTheme.of(context).followDevice,
            ),
          ],
          Divider(),
          AutoScrollTag(
            child: ListTile(
              title: Text(
                "Merkheft",
                style: Theme.of(context).textTheme.headline,
              ),
            ),
            controller: controller,
            index: 2,
            key: ObjectKey(2),
          ),
          SwitchListTile(
            title: Text("Neue oder geänderte Einträge markieren"),
            onChanged: (bool value) {
              widget.onSetDashboardMarkNewOrChangedEntries(value);
            },
            value: widget.vm.dashboardMarkNewOrChangedEntries,
          ),
          SwitchListTile(
            title: Text("Beim Löschen von Erinnerungen fragen"),
            onChanged: (bool value) {
              widget.onSetAskWhenDelete(value);
            },
            value: widget.vm.askWhenDelete,
          ),
          Divider(),
          AutoScrollTag(
            child: ListTile(
              title: Text(
                "Noten",
                style: Theme.of(context).textTheme.headline,
              ),
            ),
            controller: controller,
            index: 3,
            key: ObjectKey(3),
          ),
          SwitchListTile(
            title: Text("Noten in einem Diagramm darstellen"),
            onChanged: (bool value) {
              widget.onSetShowGradesDiagram(value);
            },
            value: widget.vm.showGradesDiagram,
          ),
          SwitchListTile(
            title: Text('Durchschnitt aller Fächer anzeigen'),
            onChanged: (bool value) {
              widget.onSetShowAllSubjectsAverage(value);
            },
            value: widget.vm.showAllSubjectsAverage,
          ),
          Divider(),
          AutoScrollTag(
            child: ListTile(
              title: Text(
                "Kalender",
                style: Theme.of(context).textTheme.headline,
              ),
            ),
            controller: controller,
            index: 4,
            key: ObjectKey(4),
          ),
          ExpansionTile(
            initiallyExpanded: widget.vm.showSubjectNicks,
            title: Text("Fächerkürzel"),
            children: List.generate(
              widget.vm.subjectNicks.length + 1,
              (i) {
                if (i == 0)
                  return ListTile(
                    trailing: IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () async {
                        final newValue = await showEditSubjectNick(
                          context,
                          "",
                          "",
                          widget.vm.allSubjects,
                        );
                        if (newValue != null) {
                          widget.onSetSubjectNicks(
                            Map.fromEntries(
                                widget.vm.subjectNicks.entries.toList()
                                  ..insert(0, newValue)),
                          );
                        }
                      },
                    ),
                  );
                final key = widget.vm.subjectNicks.entries.toList()[i - 1].key;
                final value = widget.vm.subjectNicks[key];
                return ListTile(
                  title: Text(key),
                  subtitle: Text(value),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          final delete = await showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("Kürzel entfernen?"),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text("Abbrechen"),
                                      onPressed: Navigator.of(context).pop,
                                    ),
                                    RaisedButton(
                                      child: Text("Ok"),
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
                                    ),
                                  ],
                                );
                              });
                          if (delete == true)
                            widget.onSetSubjectNicks(
                              Map.of(widget.vm.subjectNicks)..remove(key),
                            );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () async {
                          final newValue = await showEditSubjectNick(
                            context,
                            key,
                            value,
                            List.of(widget.vm.allSubjects)..add(key),
                          );
                          if (newValue != null) {
                            widget.onSetSubjectNicks(
                              Map.fromEntries(
                                List.of(widget.vm.subjectNicks.entries)
                                  ..[i - 1] = newValue,
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          SwitchListTile(
            title: Text("Hinweis zum Bearbeiten von Kürzeln"),
            subtitle: Text(
                "Wird angezeigt, wenn für ein Fach kein Kürzel vorhanden ist"),
            onChanged: (bool value) {
              widget.onSetShowCalendarEditNicksBar(value);
            },
            value: widget.vm.showCalendarEditNicksBar,
          ),
          Divider(),
          AutoScrollTag(
            child: ListTile(
              title: Text(
                "Erweitert",
                style: Theme.of(context).textTheme.headline,
              ),
            ),
            controller: controller,
            index: 5,
            key: ObjectKey(5),
          ),
          if (Platform.isAndroid)
            SwitchListTile(
              title: Text("iOS Mode"),
              subtitle:
                  Text("Imitiere das Aussehen einer iOS-App (ein bisschen)"),
              onChanged: (bool value) {
                widget.onSetPlatformOverride(value);
              },
              value: DynamicTheme.of(context).platformOverride,
            ),
          ListTile(
            title: Text("Netzwerkprotokoll"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return NetworkProtocolPage();
                  },
                ),
              );
            },
          ),
          FutureBuilder(
            future: PackageInfo.fromPlatform(),
            builder: (context, info) => AboutListTile(
              child: Text("Über diese App"),
              icon: Icon(Icons.info_outline),
              applicationIcon: Container(
                child: Image.asset("assets/transparent.png"),
                width: 100,
              ),
              applicationName: "Digitales Register (Client)",
              applicationVersion: info.hasData
                  ? (info.data as PackageInfo).version
                  : "Unbekannte Version",
              aboutBoxChildren: <Widget>[
                Text("Alternativer Client für das Digitale Register.")
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<MapEntry<String, String>> showEditSubjectNick(BuildContext context,
      String key, String value, List<String> suggestions) async {
    return await showDialog(
      context: context,
      builder: (context) => EditSubjectsNicks(
        subjectName: key,
        subjectNick: value,
        suggestions: suggestions,
      ),
    );
  }
}

class EditSubjectsNicks extends StatefulWidget {
  final String subjectName;
  final String subjectNick;
  final List<String> suggestions;

  const EditSubjectsNicks(
      {Key key, this.subjectName, this.subjectNick, this.suggestions})
      : super(key: key);
  @override
  _EditSubjectsNicksState createState() => _EditSubjectsNicksState();
}

class _EditSubjectsNicksState extends State<EditSubjectsNicks> {
  TextEditingController subjectController;
  TextEditingController nickController;
  GlobalKey<AutoCompleteTextFieldState<String>> subjectKey;
  FocusNode focusNode;
  @override
  void initState() {
    subjectController = TextEditingController(text: widget.subjectName);
    nickController = TextEditingController(text: widget.subjectNick);
    subjectKey = GlobalKey<AutoCompleteTextFieldState<String>>();
    focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    subjectController.dispose();
    nickController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Kürzel bearbeiten"),
      content: Row(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text("Fach"),
              SizedBox(
                height: 27,
              ),
              Text("Kürzel"),
            ],
          ),
          SizedBox(
            width: 16,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                AutoCompleteTextField<String>(
                  key: subjectKey,
                  itemBuilder: (BuildContext context, String suggestion) {
                    return ListTile(title: Text(suggestion));
                  },
                  textChanged: (_) => setState(() {}),
                  clearOnSubmit: false,
                  itemFilter: (String suggestion, String query) {
                    return suggestion
                        .toLowerCase()
                        .contains(query.toLowerCase());
                  },
                  itemSorter: (String a, String b) {
                    return a.compareTo(b);
                  },
                  itemSubmitted: (_) {
                    FocusScope.of(context).requestFocus(focusNode);
                  },
                  textSubmitted: (_) {
                    FocusScope.of(context).requestFocus(focusNode);
                  },
                  suggestions: widget.suggestions,
                  controller: subjectController,
                ),
                TextField(
                  controller: nickController,
                  textCapitalization: TextCapitalization.sentences,
                  onChanged: (_) => setState(() {}),
                  focusNode: focusNode,
                  onSubmitted: (_) {
                    if (subjectController.text != "" &&
                        nickController.text != "") {
                      Navigator.of(context).pop(
                        MapEntry(
                          subjectController.text,
                          nickController.text,
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("Abbrechen"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        RaisedButton(
          child: Text("Fertig"),
          onPressed: subjectController.text != "" && nickController.text != ""
              ? () {
                  Navigator.of(context).pop(
                    MapEntry(
                      subjectController.text,
                      nickController.text,
                    ),
                  );
                }
              : null,
        ),
      ],
    );
  }
}
