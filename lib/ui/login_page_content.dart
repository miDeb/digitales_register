import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tuple/tuple.dart';
import 'package:url_launcher/url_launcher.dart';

import '../container/login_page.dart';

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
  final VoidCallback onRequestPassReset;
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
  final _usernameController = TextEditingController(),
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
  Tuple2<String, String?>? nonCustomServer;
  @override
  void initState() {
    safeMode = widget.vm.safeMode;
    if (widget.vm.username != null) {
      _usernameController.text = widget.vm.username!;
    }
    if (widget.vm.url != null) {
      _urlController.text = widget.vm.url!;
      for (final entry in widget.vm.servers.entries) {
        if (Uri.parse(entry.value).host == Uri.parse(widget.vm.url!).host) {
          nonCustomServer = Tuple2(entry.key, entry.value);
          _schoolController.text = entry.key;
          break;
        }
      }
    }
    _schoolFocusNode.addListener(() {
      setState(() {
        // We manually check hasFocus
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.vm.changePass && !widget.vm.mustChangePass) {
          return true;
        }
        SystemNavigator.pop();
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
                      child: TypeAheadField<String>(
                        textFieldConfiguration: TextFieldConfiguration(
                          focusNode: _schoolFocusNode,
                          autofocus: _schoolController.text.isEmpty,
                          controller: _schoolController,
                          onChanged: (v) {
                            if (widget.vm.servers[v] == null) {
                              setState(() {
                                nonCustomServer = null;
                              });
                            }
                          },
                          decoration: InputDecoration(
                            labelText: "Schule",
                            errorText: !_schoolFocusNode.hasFocus &&
                                    _schoolController.text != "Andere Schule" &&
                                    _schoolController.text.isNotEmpty &&
                                    nonCustomServer == null
                                ? "Schule nicht gefunden"
                                : null,
                          ),
                        ),
                        itemBuilder: (context, itemData) => ListTile(
                          title: Text(itemData),
                        ),
                        onSuggestionSelected: (suggestion) {
                          setState(() {
                            _schoolController.text = suggestion;
                            nonCustomServer = Tuple2(
                              suggestion,
                              widget.vm.servers[suggestion],
                            );
                            if (suggestion == "Andere Schule") {
                              nonCustomServer = null;
                              _urlController.text = ".digitalesregister.it";
                              _urlController.selection =
                                  TextSelection.fromPosition(
                                const TextPosition(offset: 0),
                              );
                            } else {
                              _urlController.text = nonCustomServer!.item2!;
                            }
                          });
                        },
                        suggestionsCallback: (String pattern) {
                          // This prevents being able to query all available
                          // schools easily, as well as initially showing a huge
                          // list of unrelated results.
                          if (pattern.trim().length < 3) {
                            return [];
                          }
                          final candidates = [
                            ...widget.vm.servers.keys
                                .where((element) => element
                                    .toLowerCase()
                                    .contains(pattern.toLowerCase()))
                                .toList()
                                  ..sort(),
                            "Andere Schule",
                          ];
                          // Only too general querys (e.g. "Grundschule") have
                          // that many candidates. Demand more letters from the user.
                          if (candidates.length > 15) {
                            return [];
                          }
                          return candidates;
                        },
                        noItemsFoundBuilder: (context) {
                          return const ListTile(
                            title: Text(
                              "Bitte gib den Namen der Schule ein",
                              style: TextStyle(color: Colors.grey),
                            ),
                          );
                        },
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          primary: Colors.grey,
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                        ),
                        onPressed: () async {
                          PackageInfo? info;
                          try {
                            info = await PackageInfo.fromPlatform();
                          } catch (e) {
                            log("failed to get app version for feedback (login)");
                          }
                          launch(
                            // ignore: prefer_interpolation_to_compose_strings
                            "https://docs.google.com/forms/d/e/1FAIpQLSep4nbDf0G2UjzGF_S2e_w-dDYo3WJAR_0RxGK5rXwgtZblOQ/viewform?usp=pp_url" +
                                (info?.version != null
                                    ? "&entry.1581750442=${Uri.encodeQueryComponent(info!.version)}"
                                    : ""),
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
                                primary: Colors.grey,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                              ),
                              onPressed: widget.onRequestPassReset,
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
                                        nonCustomServer?.item2 ??
                                            _urlController.text,
                                      );
                                    } else {
                                      widget.onLogin(
                                        _usernameController.value.text,
                                        _passwordController.value.text,
                                        nonCustomServer?.item2 ??
                                            _urlController.text,
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
                    const ListTile(
                      title: Text("Andere Accounts"),
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
                        ? Text(
                            widget.vm.noInternet
                                ? "Keine Verbindung möglich"
                                : widget.vm.error!,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2!
                                .copyWith(color: Colors.red),
                          )
                        : const SizedBox(),
                  ),
                ],
              ),
            ),
            if (widget.vm.loading) const LinearProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
