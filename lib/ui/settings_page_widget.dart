import 'dart:developer';
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

enum _Theme {
  light,
  dark,
  followDevice,
}

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
  final OnSettingChanged<List<String>> onSetIgnoreForGradesAverage;
  final VoidCallback onShowProfile;
  final SettingsViewModel vm;

  const SettingsPageWidget({
    Key key,
    @required this.onSetNoPassSaving,
    @required this.onSetNoDataSaving,
    @required this.onSetAskWhenDelete,
    @required this.onSetDeleteDataOnLogout,
    @required this.onSetOfflineEnabled,
    @required this.onSetShowCalendarEditNicksBar,
    @required this.onSetShowGradesDiagram,
    @required this.onSetShowAllSubjectsAverage,
    @required this.onSetDashboardMarkNewOrChangedEntries,
    @required this.onSetDashboardDeduplicateEntries,
    @required this.onSetDarkMode,
    @required this.onSetSubjectNicks,
    @required this.vm,
    @required this.onSetPlatformOverride,
    @required this.onSetFollowDeviceDarkMode,
    @required this.onShowProfile,
    @required this.onSetIgnoreForGradesAverage,
  }) : super(key: key);

  @override
  _SettingsPageWidgetState createState() => _SettingsPageWidgetState();
}

class _SettingsPageWidgetState extends State<SettingsPageWidget> {
  final controller = AutoScrollController();

  List<String> get subjectsWithoutNick => widget.vm.allSubjects
      .where((element) => !widget.vm.subjectNicks.keys.contains(element))
      .toList();
  List<String> get notYetIgnoredForAverageSubjects => widget.vm.allSubjects
      .where((element) => !widget.vm.ignoreForGradesAverage.contains(element))
      .toList();

  @override
  void initState() {
    if (widget.vm.showSubjectNicks) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await controller.scrollToIndex(4,
            preferPosition: AutoScrollPosition.begin);
        final newValue =
            await showEditSubjectNick(context, "", "", subjectsWithoutNick);
        if (newValue != null) {
          widget.onSetSubjectNicks(
            Map.fromEntries(
                widget.vm.subjectNicks.entries.toList()..insert(0, newValue)),
          );
        }
      });
    }
    if (widget.vm.showGradesSettings) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.scrollToIndex(3, preferPosition: AutoScrollPosition.begin);
      });
    }
    super.initState();
  }

  void _selectTheme(_Theme theme) {
    setState(() {
      switch (theme) {
        case _Theme.light:
          widget.onSetFollowDeviceDarkMode(false);
          widget.onSetDarkMode(false);
          break;
        case _Theme.dark:
          widget.onSetFollowDeviceDarkMode(false);
          widget.onSetDarkMode(true);
          break;
        case _Theme.followDevice:
          widget.onSetFollowDeviceDarkMode(true);
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.vm.showSubjectNicks) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        controller.scrollToIndex(4, preferPosition: AutoScrollPosition.begin);
      });
    }
    final currentTheme = DynamicTheme.of(context).followDevice
        ? _Theme.followDevice
        : DynamicTheme.of(context).customBrightness == Brightness.dark
            ? _Theme.dark
            : _Theme.light;
    return Scaffold(
      appBar: const ResponsiveAppBar(
        title: Text("Einstellungen"),
      ),
      body: ListView(
        controller: controller,
        children: <Widget>[
          const SizedBox(height: 8),
          ListTile(
            title: Text(
              "Profil",
              style: Theme.of(context).textTheme.headline5,
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: widget.onShowProfile,
          ),
          const Divider(),
          AutoScrollTag(
            controller: controller,
            index: 0,
            key: const ObjectKey(0),
            child: ListTile(
              title: Text(
                "Anmeldung",
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
          ),
          SwitchListTile.adaptive(
            title: const Text("Angemeldet bleiben"),
            subtitle: const Text("Deine Zugangsdaten werden lokal gespeichert"),
            onChanged: (bool value) {
              widget.onSetNoPassSaving(!value);
            },
            value: !widget.vm.noPassSaving,
          ),
          SwitchListTile.adaptive(
            title: const Text("Daten lokal speichern"),
            subtitle: const Text('Sehen, wann etwas eingetragen wurde'),
            onChanged: (bool value) {
              widget.onSetNoDataSaving(!value);
            },
            value: !widget.vm.noDataSaving,
          ),
          SwitchListTile.adaptive(
            title: const Text("Offline-Login"),
            onChanged: !widget.vm.noPassSaving && !widget.vm.noDataSaving
                ? (bool value) {
                    widget.onSetOfflineEnabled(value);
                  }
                : null,
            value: widget.vm.offlineEnabled,
          ),
          SwitchListTile.adaptive(
            title: const Text("Daten beim Ausloggen löschen"),
            onChanged: !widget.vm.noPassSaving && !widget.vm.noDataSaving
                ? (bool value) {
                    widget.onSetDeleteDataOnLogout(value);
                  }
                : null,
            value: widget.vm.deleteDataOnLogout,
          ),
          const Divider(),
          AutoScrollTag(
            controller: controller,
            index: 1,
            key: const ObjectKey(1),
            child: ListTile(
              title: Text(
                "Theme",
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
          ),
          RadioListTile(
            value: _Theme.followDevice,
            groupValue: currentTheme,
            onChanged: _selectTheme,
            title: const Text("Geräte-Theme folgen"),
          ),
          RadioListTile(
            value: _Theme.light,
            groupValue: currentTheme,
            onChanged: _selectTheme,
            title: const Text("Hell"),
          ),
          RadioListTile(
            value: _Theme.dark,
            groupValue: currentTheme,
            onChanged: _selectTheme,
            title: const Text("Dunkel"),
          ),
          const Divider(),
          AutoScrollTag(
            controller: controller,
            index: 2,
            key: const ObjectKey(2),
            child: ListTile(
              title: Text(
                "Merkheft",
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
          ),
          SwitchListTile.adaptive(
            title: const Text("Neue oder geänderte Einträge markieren"),
            onChanged: (bool value) {
              widget.onSetDashboardMarkNewOrChangedEntries(value);
            },
            value: widget.vm.dashboardMarkNewOrChangedEntries,
          ),
          SwitchListTile.adaptive(
            title: const Text("Doppelte Einträge ignorieren"),
            onChanged: (bool value) {
              widget.onSetDashboardDeduplicateEntries(value);
            },
            value: widget.vm.dashboardDeduplicateEntries,
          ),
          SwitchListTile.adaptive(
            title: const Text("Beim Löschen von Erinnerungen fragen"),
            onChanged: (bool value) {
              widget.onSetAskWhenDelete(value);
            },
            value: widget.vm.askWhenDelete,
          ),
          const Divider(),
          AutoScrollTag(
            controller: controller,
            index: 3,
            key: const ObjectKey(3),
            child: ListTile(
              title: Text(
                "Noten",
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
          ),
          SwitchListTile.adaptive(
            title: const Text("Noten in einem Diagramm darstellen"),
            onChanged: (bool value) {
              widget.onSetShowGradesDiagram(value);
            },
            value: widget.vm.showGradesDiagram,
          ),
          SwitchListTile.adaptive(
            title: const Text('Durchschnitt aller Fächer anzeigen'),
            onChanged: (bool value) {
              widget.onSetShowAllSubjectsAverage(value);
            },
            value: widget.vm.showAllSubjectsAverage,
          ),
          ListTile(
            title: const Text("Fächer für den Notendurchchnitt ignorieren"),
            trailing: IconButton(
              icon: const Icon(Icons.add),
              onPressed: () async {
                final newSubject = await showDialog<String>(
                  context: context,
                  builder: (context) => AddSubject(
                    availableSubjects: notYetIgnoredForAverageSubjects,
                  ),
                );
                if (newSubject != null) {
                  widget.onSetIgnoreForGradesAverage(
                      widget.vm.ignoreForGradesAverage..add(newSubject));
                }
              },
            ),
          ),
          if (widget.vm.ignoreForGradesAverage.isEmpty)
            const Padding(
              padding: EdgeInsets.only(left: 16),
              child: ListTile(
                  title: Text(
                "Kein Fach wird ignoriert",
                style: TextStyle(color: Colors.grey),
              )),
            )
          else
            for (final subject in widget.vm.ignoreForGradesAverage)
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: ListTile(
                  title: Text(subject),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.close,
                    ),
                    onPressed: () {
                      widget.onSetIgnoreForGradesAverage(
                        widget.vm.ignoreForGradesAverage..remove(subject),
                      );
                    },
                  ),
                ),
              ),
          const Divider(),
          AutoScrollTag(
            controller: controller,
            index: 4,
            key: const ObjectKey(4),
            child: ListTile(
              title: Text(
                "Kalender",
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
          ),
          ExpansionTile(
            initiallyExpanded: widget.vm.showSubjectNicks,
            title: const Text("Fächerkürzel"),
            children: List.generate(
              widget.vm.subjectNicks.length + 1,
              (i) {
                if (i == 0) {
                  return ListTile(
                    trailing: IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () async {
                        final newValue = await showEditSubjectNick(
                          context,
                          "",
                          "",
                          subjectsWithoutNick,
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
                }
                i -= 1;
                final key = widget.vm.subjectNicks.entries.toList()[i].key;
                final value = widget.vm.subjectNicks[key];
                return ListTile(
                  title: Text(key),
                  subtitle: Text(value),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          final delete = await showDialog(
                              context: context,
                              builder: (context) {
                                return InfoDialog(
                                  title: const Text("Kürzel entfernen?"),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: Navigator.of(context).pop,
                                      child: const Text("Abbrechen"),
                                    ),
                                    ElevatedButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
                                      child: const Text("Ok"),
                                    ),
                                  ],
                                );
                              });
                          if (delete == true) {
                            widget.onSetSubjectNicks(
                              Map.of(widget.vm.subjectNicks)..remove(key),
                            );
                          }
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () async {
                          final newValue = await showEditSubjectNick(
                            context,
                            key,
                            value,
                            subjectsWithoutNick..add(key),
                          );
                          if (newValue != null) {
                            widget.onSetSubjectNicks(
                              Map.fromEntries(
                                List.of(widget.vm.subjectNicks.entries)
                                  ..[i] = newValue,
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
            title: const Text("Hinweis zum Bearbeiten von Kürzeln"),
            subtitle: const Text(
                "Wird angezeigt, wenn für ein Fach kein Kürzel vorhanden ist"),
            onChanged: (bool value) {
              widget.onSetShowCalendarEditNicksBar(value);
            },
            value: widget.vm.showCalendarEditNicksBar,
          ),
          const Divider(),
          AutoScrollTag(
            controller: controller,
            index: 5,
            key: const ObjectKey(5),
            child: ListTile(
              title: Text(
                "Erweitert",
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
          ),
          if (Platform.isAndroid)
            SwitchListTile.adaptive(
              title: const Text("iOS Mode"),
              subtitle: const Text(
                  "Imitiere das Aussehen einer iOS-App (ein bisschen)"),
              onChanged: (bool value) {
                widget.onSetPlatformOverride(value);
              },
              value: DynamicTheme.of(context).platformOverride,
            ),
          ListTile(
            title: const Text("Netzwerkprotokoll"),
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
            title: const Text("Feedback geben"),
            trailing: const Icon(Icons.open_in_new),
            onTap: () async {
              PackageInfo info;
              try {
                info = await PackageInfo.fromPlatform();
              } catch (e) {
                log("failed to get app version for feedback (settings)");
              }
              launch(
                // ignore: prefer_interpolation_to_compose_strings
                "https://docs.google.com/forms/d/e/1FAIpQLSerGRl3T_segGmFlVjl3NbEgxjfvI3XpxfMNKDAAfB614vbDQ/viewform?usp=pp_url" +
                    (info?.version != null
                        ? "&entry.1362624919=${Uri.encodeQueryComponent(info.version)}"
                        : ""),
              );
            },
          ),
          ListTile(
            title: const Text(
              "Unterstütze uns jetzt!",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Donate()));
            },
          ),
          FutureBuilder(
            future: PackageInfo.fromPlatform(),
            builder: (context, info) => AboutListTile(
              icon: const Icon(Icons.info_outline),
              applicationIcon: SizedBox(
                width: 100,
                child: Image.asset("assets/transparent.png"),
              ),
              applicationLegalese:
                  "Michael Debertol und Simon Wachtler 2019-2021",
              applicationName: "Digitales Register (Client)",
              applicationVersion: info.hasData
                  ? (info.data as PackageInfo).version
                  : "Unbekannte Version",
              aboutBoxChildren: const [
                Text(
                    "Ein Client für das Digitale Register.\nGroßes Dankeschön an das Vinzentinum für die freundliche Unterstützung."),
              ],
              child: const Text("Über diese App"),
            ),
          ),
        ],
      ),
    );
  }

  Future<MapEntry<String, String>> showEditSubjectNick(BuildContext context,
      String key, String value, List<String> suggestions) async {
    return showDialog(
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
      title: Text("Kürzel ${forNewNick ? "hinzufügen" : "bearbeiten"}"),
      content: Row(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text("Fach"),
              SizedBox(
                height: 27,
              ),
              Text("Kürzel"),
            ],
          ),
          const SizedBox(
            width: 16,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TypeAheadField<String>(
                  suggestionsCallback: (pattern) {
                    return widget.suggestions.where((suggestion) => suggestion
                        .toLowerCase()
                        .contains(pattern.toLowerCase()));
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
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Abbrechen"),
        ),
        ElevatedButton(
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
          child: const Text("Fertig"),
        ),
      ],
    );
  }
}

class AddSubject extends StatefulWidget {
  final List<String> availableSubjects;

  const AddSubject({Key key, this.availableSubjects}) : super(key: key);
  @override
  _AddSubjectState createState() => _AddSubjectState();
}

class _AddSubjectState extends State<AddSubject> {
  TextEditingController subjectController;
  @override
  void initState() {
    subjectController = TextEditingController();
    subjectController.addListener(() {
      setState(() {
        // if the subjectController's text changed, we might update the buttons
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    subjectController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InfoDialog(
      title: const Text("Fach hinzufügen"),
      content: TypeAheadField<String>(
        suggestionsCallback: (pattern) {
          return widget.availableSubjects.where((suggestion) =>
              suggestion.toLowerCase().contains(pattern.toLowerCase()));
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
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Abbrechen"),
        ),
        ElevatedButton(
          onPressed: subjectController.text != ""
              ? () {
                  Navigator.of(context).pop(subjectController.text);
                }
              : null,
          child: const Text("Fertig"),
        ),
      ],
    );
  }
}
