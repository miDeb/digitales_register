// Copyright (C) 2021 Michael Debertol
//
// This file is part of digitales_register.
//
// digitales_register is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// digitales_register is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with digitales_register.  If not, see <http://www.gnu.org/licenses/>.

import 'package:collection/collection.dart';
import 'package:dr/container/login_page.dart';
import 'package:dr/ui/animated_linear_progress_indicator.dart';
import 'package:dr/ui/autocomplete_options.dart';
import 'package:dr/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fuzzy/fuzzy.dart';
import 'package:tuple/tuple.dart';
import 'package:url_launcher/url_launcher.dart';

typedef LoginCallback = void Function(String user, String pass, String url);
typedef ChangePassCallback = void Function(
    String user, String oldPass, String newPass, String url);
typedef SetSafeModeCallback = void Function(bool safeMode);
typedef SelectAccountCallback = void Function(int index);

class LoginPageContent extends StatefulWidget {
  final LoginPageViewModel vm;
  final LoginCallback onLogin;
  final ChangePassCallback onChangePass;
  final SetSafeModeCallback setSaveNoPass;
  final VoidCallback onReload;
  final void Function(String url) onRequestPassReset;
  final SelectAccountCallback onSelectAccount;

  const LoginPageContent({
    Key? key,
    required this.vm,
    required this.onLogin,
    required this.setSaveNoPass,
    required this.onReload,
    required this.onChangePass,
    required this.onRequestPassReset,
    required this.onSelectAccount,
  }) : super(key: key);

  @override
  _LoginPageContentState createState() => _LoginPageContentState();
}

class _LoginPageContentState extends State<LoginPageContent> {
  late final _usernameController = TextEditingController(),
      _passwordController = TextEditingController(),
      _newPassword1Controller = TextEditingController(),
      _newPassword2Controller = TextEditingController(),
      _schoolController = TextEditingController(),
      _urlController = TextEditingController.fromValue(
        TextEditingValue(
          text: ".digitalesregister.it",
          selection: TextSelection.fromPosition(
            const TextPosition(offset: 0),
          ),
        ),
      );
  final _schoolFocusNode = FocusNode();
  late bool safeMode;
  bool newPasswordsMatch = true;
  Tuple2<String, String?>? selectedPresetServer;
  @override
  void initState() {
    safeMode = widget.vm.safeMode;
    if (widget.vm.username != null) {
      _usernameController.text = widget.vm.username!;
    }
    if (widget.vm.url != null) {
      _urlController.text = widget.vm.url!;
      final school = widget.vm.servers.entries.firstWhereOrNull(
        (entry) =>
            Uri.parse(entry.value).host == Uri.parse(widget.vm.url!).host,
      );
      if (school != null) {
        selectedPresetServer = Tuple2(school.key, school.value);
        _schoolController.text = school.key;
      } else {
        _schoolController.text = "Andere Schule";
      }
    }
    _schoolFocusNode.addListener(() {
      setState(() {
        // We manually check hasFocus
      });
    });
    super.initState();
  }

  String get url => selectedPresetServer?.item2 ?? _urlController.text;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.vm.changePass && !widget.vm.mustChangePass) {
          return true;
        }
        await SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.vm.changePass ? 'Passwort ändern' : 'Login'),
          automaticallyImplyLeading:
              widget.vm.changePass && !widget.vm.mustChangePass,
        ),
        body: Stack(
          children: [
            Center(
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  if (!widget.vm.changePass) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      // TODO: Remove once https://github.com/flutter/flutter/issues/78746 is fixed.
                      child: LayoutBuilder(builder: (context, constraints) {
                        return RawAutocomplete<String>(
                          focusNode: _schoolFocusNode,
                          textEditingController: _schoolController,
                          optionsViewBuilder: (context, onSelected, options) {
                            return AutocompleteOptions(
                              displayStringForOption:
                                  RawAutocomplete.defaultStringForOption,
                              onSelected: onSelected,
                              options: options,
                              maxOptionsHeight: 200,
                              width: constraints.maxWidth,
                            );
                          },
                          fieldViewBuilder: (context, textEditingController,
                              focusNode, onFieldSubmitted) {
                            return TextFormField(
                              controller: textEditingController,
                              focusNode: focusNode,
                              onFieldSubmitted: (String value) {
                                onFieldSubmitted();
                              },
                              autofocus: _schoolController.text.isEmpty,
                              enabled: !widget.vm.loading,
                              onChanged: (value) {
                                setState(() {
                                  if (widget.vm.servers[value] == null) {
                                    selectedPresetServer = null;
                                  } else {
                                    selectedPresetServer =
                                        Tuple2(value, widget.vm.servers[value]);
                                    _urlController.text =
                                        selectedPresetServer!.item2!;
                                  }
                                });
                              },
                              decoration: InputDecoration(
                                labelText: "Schule",
                                errorText: !_schoolFocusNode.hasFocus &&
                                        _schoolController.text !=
                                            "Andere Schule" &&
                                        _schoolController.text.isNotEmpty &&
                                        selectedPresetServer == null
                                    ? "Schule nicht gefunden"
                                    : null,
                              ),
                            );
                          },
                          optionsBuilder: (textEditingValue) {
                            // Require at least three input characters.
                            if (textEditingValue.text.trim().length < 3) {
                              return [];
                            }

                            // If we found a perfect match, do not show other options.
                            if (widget.vm.servers
                                .containsKey(textEditingValue.text)) {
                              return [
                                textEditingValue.text,
                              ];
                            }

                            return [
                              ...Fuzzy(
                                widget.vm.servers.keys.toList(),
                                options: FuzzyOptions<String>(
                                  maxPatternLength: 256,
                                  tokenize: true,
                                ),
                              )
                                  .search(textEditingValue.text)
                                  .take(15)
                                  .map((e) => e.item),
                              "Andere Schule",
                            ];
                          },
                          onSelected: (option) {
                            setState(() {
                              _schoolController.text = option;
                              selectedPresetServer = Tuple2(
                                option,
                                widget.vm.servers[option],
                              );
                              if (option == "Andere Schule") {
                                selectedPresetServer = null;
                                _urlController.text = ".digitalesregister.it";
                                _urlController.selection =
                                    TextSelection.fromPosition(
                                  const TextPosition(offset: 0),
                                );
                              } else {
                                _urlController.text =
                                    selectedPresetServer!.item2!;
                              }
                            });
                          },
                        );
                      }),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.grey,
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                        ),
                        onPressed: () async {
                          await launchUrl(
                            Uri.https(
                              "docs.google.com",
                              "/forms/d/e/1FAIpQLSep4nbDf0G2UjzGF_S2e_w-dDYo3WJAR_0RxGK5rXwgtZblOQ/viewform",
                              <String, String>{
                                "usp": "pp_url",
                                "entry.1581750442": appVersion,
                              },
                            ),
                          );
                        },
                        child: const Text("Feedback?"),
                      ),
                    ),
                  ],
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: AutofillGroup(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (!widget.vm.changePass) ...[
                            TextField(
                              decoration:
                                  const InputDecoration(labelText: 'Adresse'),
                              controller: _urlController,
                              enabled: !widget.vm.loading,
                              keyboardType: TextInputType.url,
                            ),
                            const Divider(),
                          ],
                          TextField(
                            // Remove this check when (if?) https://github.com/flutter/flutter/issues/67136 is resolved
                            autofillHints: widget.vm.loading
                                ? null
                                : [AutofillHints.username],
                            decoration: const InputDecoration(
                                labelText: 'Benutzername'),
                            controller: _usernameController,
                            enabled: !widget.vm.loading,
                          ),
                          TextField(
                            autofillHints: widget.vm.loading
                                ? null
                                : [AutofillHints.password],
                            decoration: InputDecoration(
                                labelText: widget.vm.changePass
                                    ? 'Altes Passwort'
                                    : 'Passwort'),
                            controller: _passwordController,
                            obscureText: true,
                            enabled: !widget.vm.loading,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.grey,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                              ),
                              onPressed: () => widget.onRequestPassReset(url),
                              child: const Text(
                                "Passwort vergessen",
                              ),
                            ),
                          ),
                          if (widget.vm.changePass) ...[
                            const SizedBox(
                              height: 8,
                            ),
                            if (widget.vm.mustChangePass)
                              const ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  "Du musst dein Passwort ändern:",
                                ),
                              ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 0,
                                ),
                              ),
                              padding: const EdgeInsets.all(8),
                              child: const Text(
                                "Das neue Passwort muss:\n"
                                "- mindestens 10 Zeichen lang sein\n"
                                "- mindestens einen Großbuchstaben enthalten\n"
                                "- mindestens einen Kleinbuchstaben enthalten\n"
                                "- mindestens eine Zahl enthalten\n"
                                "- mindestens ein Sonderzeichen enthalten\n"
                                "- nicht mit dem alten Passwort übereinstimmen",
                              ),
                            ),
                            TextField(
                              autofillHints: widget.vm.loading
                                  ? null
                                  : [AutofillHints.newPassword],
                              decoration: const InputDecoration(
                                  labelText: 'Neues Passwort'),
                              controller: _newPassword1Controller,
                              obscureText: true,
                              enabled: !widget.vm.loading,
                              onChanged: (_) {
                                setState(() {
                                  newPasswordsMatch =
                                      _newPassword1Controller.text ==
                                          _newPassword2Controller.text;
                                });
                              },
                            ),
                            TextField(
                              autofillHints: widget.vm.loading
                                  ? null
                                  : [AutofillHints.newPassword],
                              decoration: InputDecoration(
                                labelText: 'Neues Passwort wiederholen',
                                errorText: newPasswordsMatch
                                    ? null
                                    : "Die neuen Passwörter stimmen nicht überein",
                              ),
                              controller: _newPassword2Controller,
                              obscureText: true,
                              enabled: !widget.vm.loading,
                              onChanged: (_) {
                                setState(() {
                                  newPasswordsMatch =
                                      _newPassword1Controller.text ==
                                          _newPassword2Controller.text;
                                });
                              },
                            ),
                          ],
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: widget.vm.loading || !newPasswordsMatch
                                ? null
                                : () {
                                    widget.setSaveNoPass(safeMode);
                                    if (widget.vm.changePass) {
                                      widget.onChangePass(
                                        _usernameController.text,
                                        _passwordController.text,
                                        _newPassword1Controller.text,
                                        url,
                                      );
                                    } else {
                                      widget.onLogin(
                                        _usernameController.value.text,
                                        _passwordController.value.text,
                                        url,
                                      );
                                    }
                                  },
                            child: Text(
                              widget.vm.changePass
                                  ? 'Passwort ändern'
                                  : 'Login',
                            ),
                          ),
                          const Divider(),
                        ],
                      ),
                    ),
                  ),
                  SwitchListTile.adaptive(
                    title: const Text("Angemeldet bleiben"),
                    subtitle: const Text(
                        "Deine Zugangsdaten werden lokal gespeichert"),
                    value: !safeMode,
                    onChanged: widget.vm.loading
                        ? null
                        : (bool value) {
                            setState(() {
                              safeMode = !value;
                            });
                          },
                  ),
                  if (!widget.vm.changePass &&
                      widget.vm.otherAccounts.isNotEmpty) ...[
                    const Divider(
                      height: 16,
                    ),
                    ListTile(
                      title: Text(
                        "Andere Accounts",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    Column(
                      children: [
                        for (var index = 0;
                            index < widget.vm.otherAccounts.length;
                            index++)
                          ListTile(
                            title: Text(widget.vm.otherAccounts[index]),
                            onTap: () => widget.onSelectAccount(index),
                          ),
                      ],
                    ),
                  ],
                  Center(
                    child: widget.vm.error?.isNotEmpty == true
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              widget.vm.noInternet
                                  ? 'Keine Verbindung mit "${widget.vm.url}" möglich. Bitte überprüfe deine Internetverbindung.\nWenn du "Andere Schule" ausgewählt hast, musst du eine gültige Adresse eingeben.'
                                  : widget.vm.error!,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(color: Colors.red),
                            ),
                          )
                        : const SizedBox(),
                  ),
                ],
              ),
            ),
            AnimatedLinearProgressIndicator(show: widget.vm.loading),
          ],
        ),
      ),
    );
  }
}
