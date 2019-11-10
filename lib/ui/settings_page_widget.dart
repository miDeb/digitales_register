import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';

import '../container/settings_page.dart';
import 'network_protocol_page.dart';

class SettingsPageWidget extends StatelessWidget {
  final SettingsViewModel vm;

  const SettingsPageWidget({Key key, this.vm}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Einstellungen"),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text(
              "Anmeldung",
              style: Theme.of(context).textTheme.headline,
            ),
          ),
          SwitchListTile(
            title: Text("Angemeldet bleiben"),
            onChanged: (bool value) {
              vm.onSetNoPassSaving(!value);
            },
            value: !vm.noPassSaving,
          ),
          SwitchListTile(
            title: Text("Daten lokal speichern"),
            subtitle: Text('Sehen, wann etwas eingetragen wurde'),
            onChanged: (bool value) {
              vm.onSetNoDataSaving(!value);
            },
            value: !vm.noDataSaving,
          ),
          SwitchListTile(
            title: Text("Offline-Login"),
            onChanged: !vm.noPassSaving && !vm.noDataSaving
                ? (bool value) {
                    vm.onSetOfflineEnabled(value);
                  }
                : null,
            value: vm.offlineEnabled,
          ),
          SwitchListTile(
            title: Text("Daten beim Ausloggen löschen"),
            onChanged: !vm.noPassSaving && !vm.noDataSaving
                ? (bool value) {
                    vm.onSetDeleteDataOnLogout(value);
                  }
                : null,
            value: vm.deleteDataOnLogout,
          ),
          Divider(),
          ListTile(
            title: Text(
              "Erscheinung",
              style: Theme.of(context).textTheme.headline,
            ),
          ),
          SwitchListTile(
            title: Text("Dark Mode"),
            onChanged:
                MediaQuery.of(context).platformBrightness == Brightness.dark
                    ? null
                    : (bool value) {
                        vm.onSetDarkMode(value);
                      },
            value: DynamicTheme.of(context).brightness == Brightness.dark,
          ),
          Divider(),
          ListTile(
            title: Text(
              "Merkheft",
              style: Theme.of(context).textTheme.headline,
            ),
          ),
          SwitchListTile(
            title: Text("Beim Löschen von Erinnerungen fragen"),
            onChanged: (bool value) {
              vm.onSetAskWhenDelete(value);
            },
            value: vm.askWhenDelete,
          ),
          Divider(),
          ListTile(
            title: Text(
              "Noten",
              style: Theme.of(context).textTheme.headline,
            ),
          ),
          SwitchListTile(
            title: Text(
                'Keinen Notendurchschnitt berechnen, wenn "Beide Semester" ausgewählt ist'),
            onChanged: (bool value) {
              vm.onSetNoAverageForAllSemester(value);
            },
            value: vm.noAverageForAllSemester,
          ),
          Divider(),
          ListTile(
            title: Text(
              "Kalender",
              style: Theme.of(context).textTheme.headline,
            ),
          ),
          ExpansionTile(
              title: Text("Fächerkürzel"),
              children: List.generate(vm.subjectNicks.length + 1, (i) {
                if (i == 0)
                  return ListTile(
                    trailing: IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () async {
                        final newValue =
                            await showEditSubjectNick(context, "", "");
                        if (newValue != null) {
                          vm.onSetSubjectNicks(
                            Map.of(vm.subjectNicks)
                              ..[newValue.key] = newValue.value,
                          );
                        }
                      },
                    ),
                  );
                final key = vm.subjectNicks.entries.toList()[i - 1].key;
                final value = vm.subjectNicks[key];
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
                            vm.onSetSubjectNicks(
                              Map.of(vm.subjectNicks)..remove(key),
                            );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () async {
                          final newValue =
                              await showEditSubjectNick(context, key, value);
                          if (newValue != null) {
                            vm.onSetSubjectNicks(
                              Map.fromEntries(
                                List.of(vm.subjectNicks.entries)
                                  ..[i - 1] = newValue,
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                );
              })),
          Divider(),
          ListTile(
            title: Text(
              "Erweitert",
              style: Theme.of(context).textTheme.headline,
            ),
          ),
          ListTile(
            title: Text("Netzwerkprotokoll"),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return NetworkProtocolPage();
              }));
            },
          ),
        ],
      ),
    );
  }

  Future<MapEntry<String, String>> showEditSubjectNick(
      BuildContext context, String key, String value) async {
    return await showDialog(
      context: context,
      builder: (context) {
        final subjectController = TextEditingController(text: key);
        final nickController = TextEditingController(text: value);
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Kürzel bearbeiten"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: Text("Fach"),
                    trailing: SizedBox(
                      width: 100,
                      child: TextField(
                        controller: subjectController,
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text("Kürzel"),
                    trailing: SizedBox(
                      width: 100,
                      child: TextField(
                        controller: nickController,
                        onChanged: (_) => setState(() {}),
                      ),
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
                  onPressed:
                      subjectController.text != "" && nickController.text != ""
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
          },
        );
      },
    );
  }
}
