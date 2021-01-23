import 'dart:io';

import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:package_info/package_info.dart';
import 'package:responsive_scaffold/responsive_scaffold.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:url_launcher/url_launcher.dart';

import '../container/settings_page.dart';
import 'dialog.dart';
import 'donations.dart';
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
  final OnSettingChanged<bool> onSetDashboardDeduplicateEntries;
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
    this.onSetDashboardDeduplicateEntries,
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
        await controller.scrollToIndex(4,
            preferPosition: AutoScrollPosition.begin);
        showEditSubjectNick(context, "", "", widget.vm.allSubjects);
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
      appBar: ResponsiveAppBar(
        title: Text("Einstellungen"),
      ),
      body: ListView(
        controller: controller,
        children: <Widget>[
          SizedBox(height: 8),
          ListTile(
            title: Text(
              "Profil",
              style: Theme.of(context).textTheme.headline5,
            ),
            trailing: Icon(Icons.chevron_right),
            onTap: widget.onShowProfile,
          ),
          Divider(),
          AutoScrollTag(
            child: ListTile(
              title: Text(
                "Anmeldung",
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            controller: controller,
            index: 0,
            key: ObjectKey(0),
          ),
          SwitchListTile.adaptive(
            title: Text("Angemeldet bleiben"),
            subtitle: Text("Deine Zugangsdaten werden lokal gespeichert"),
            onChanged: (bool value) {
              widget.onSetNoPassSaving(!value);
            },
            value: !widget.vm.noPassSaving,
          ),
          SwitchListTile.adaptive(
            title: Text("Daten lokal speichern"),
            subtitle: Text('Sehen, wann etwas eingetragen wurde'),
            onChanged: (bool value) {
              widget.onSetNoDataSaving(!value);
            },
            value: !widget.vm.noDataSaving,
          ),
          SwitchListTile.adaptive(
            title: Text("Offline-Login"),
            onChanged: !widget.vm.noPassSaving && !widget.vm.noDataSaving
                ? (bool value) {
                    widget.onSetOfflineEnabled(value);
                  }
                : null,
            value: widget.vm.offlineEnabled,
          ),
          SwitchListTile.adaptive(
            title: Text("Daten beim Ausloggen löschen"),
            onChanged: !widget.vm.noPassSaving && !widget.vm.noDataSaving
                ? (bool value) {
                    widget.onSetDeleteDataOnLogout(value);
                  }
                : null,
            value: widget.vm.deleteDataOnLogout,
          ),
          Divider(),
          AutoScrollTag(
            child: ListTile(
              title: Text(
                "Theme",
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            controller: controller,
            index: 1,
            key: ObjectKey(1),
          ),
          SwitchListTile.adaptive(
            title: Text("Dark Mode"),
            onChanged: DynamicTheme.of(context).followDevice
                ? null
                : (bool value) {
                    setState(() {
                      widget.onSetDarkMode(value);
                    });
                  },
            value: DynamicTheme.of(context).customBrightness == Brightness.dark,
          ),
          SwitchListTile.adaptive(
            title: Text("Geräte-Theme folgen"),
            onChanged: (bool value) {
              setState(() {
                widget.onSetFollowDeviceDarkMode(value);
              });
            },
            value: DynamicTheme.of(context).followDevice,
          ),
          Divider(),
          AutoScrollTag(
            child: ListTile(
              title: Text(
                "Merkheft",
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            controller: controller,
            index: 2,
            key: ObjectKey(2),
          ),
          SwitchListTile.adaptive(
            title: Text("Neue oder geänderte Einträge markieren"),
            onChanged: (bool value) {
              widget.onSetDashboardMarkNewOrChangedEntries(value);
            },
            value: widget.vm.dashboardMarkNewOrChangedEntries,
          ),
          SwitchListTile.adaptive(
            title: Text("Doppelte Einträge ignorieren"),
            onChanged: (bool value) {
              widget.onSetDashboardDeduplicateEntries(value);
            },
            value: widget.vm.dashboardDeduplicateEntries,
          ),
          SwitchListTile.adaptive(
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
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            controller: controller,
            index: 3,
            key: ObjectKey(3),
          ),
          SwitchListTile.adaptive(
            title: Text("Noten in einem Diagramm darstellen"),
            onChanged: (bool value) {
              widget.onSetShowGradesDiagram(value);
            },
            value: widget.vm.showGradesDiagram,
          ),
          SwitchListTile.adaptive(
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
                style: Theme.of(context).textTheme.headline5,
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
                                return InfoDialog(
                                  title: Text("Kürzel entfernen?"),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text("Abbrechen"),
                                      onPressed: Navigator.of(context).pop,
                                    ),
                                    ElevatedButton(
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
          SwitchListTile.adaptive(
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
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            controller: controller,
            index: 5,
            key: ObjectKey(5),
          ),
          if (Platform.isAndroid)
            SwitchListTile.adaptive(
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
          ListTile(
            title: Text("Feedback geben"),
            trailing: Icon(Icons.open_in_new),
            onTap: () {
              launch("https://form.jotform.com/210060844853351");
            },
          ),
          ListTile(
            title: Text("Unterstütze uns!"),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Donate()));
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
              applicationLegalese:
                  "Michael Debertol und Simon Wachtler 2019-2021",
              applicationName: "Digitales Register (Client)",
              applicationVersion: info.hasData
                  ? (info.data as PackageInfo).version
                  : "Unbekannte Version",
              aboutBoxChildren: <Widget>[
                Text("Ein Client für das Digitale Register."),
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
  FocusNode focusNode;
  bool forNewNick;
  @override
  void initState() {
    forNewNick = widget.subjectName.isEmpty;
    subjectController = TextEditingController(text: widget.subjectName);
    nickController = TextEditingController(text: widget.subjectNick);
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
    return InfoDialog(
      title: Text("Kürzel " + (forNewNick ? "hinzufügen" : "bearbeiten")),
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
                TypeAheadField(
                  suggestionsCallback: (pattern) {
                    return widget.suggestions
                        .where((suggestion) => suggestion.toLowerCase().contains(pattern.toLowerCase()));
                  },
                  itemBuilder: (BuildContext context, String suggestion) {
                    return ListTile(title: Text(suggestion));
                  },
                  onSuggestionSelected: (suggestion) {
                    subjectController.text = suggestion;
                  },
                  textFieldConfiguration: TextFieldConfiguration(
                    controller: subjectController,
                    autofocus: subjectController.text.isEmpty,
                  ),
                  hideOnEmpty: true,
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
        TextButton(
          child: Text("Abbrechen"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
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
