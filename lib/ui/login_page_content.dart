import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:package_info/package_info.dart';
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

  LoginPageContent({
    Key key,
    @required this.vm,
    this.onLogin,
    this.setSaveNoPass,
    this.onReload,
    this.onChangePass,
    this.onRequestPassReset,
    this.onSelectAccount,
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
            TextPosition(offset: 0),
          ),
        ),
      );
  final _schoolFocusNode = FocusNode();
  bool safeMode;
  bool newPasswordsMatch = true;
  Tuple2<String, String> nonCustomServer;
  @override
  void initState() {
    safeMode = widget.vm.safeMode;
    _usernameController.text = widget.vm.username;
    if (widget.vm.url != null) {
      _urlController.text = widget.vm.url;
      for (final entry in widget.vm.servers.entries) {
        if (entry.value == widget.vm.url) {
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
                      child: TypeAheadField(
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
                                TextPosition(offset: 0),
                              );
                            } else {
                              _urlController.text = nonCustomServer.item2;
                            }
                          });
                        },
                        suggestionsCallback: (String pattern) {
                          return [
                            "Andere Schule",
                            ...widget.vm.servers.keys
                                .where((element) => element
                                    .toLowerCase()
                                    .contains(pattern.toLowerCase()))
                                .toList()
                                  ..sort()
                          ];
                        },
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        child: Text("Feedback?"),
                        style: TextButton.styleFrom(
                          primary: Colors.grey,
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                        ),
                        onPressed: () async {
                          PackageInfo info;
                          try {
                            info = await PackageInfo.fromPlatform();
                          } catch (e) {
                            print("failed to get app version for feedback (login)");
                          }
                          launch(
                            "https://docs.google.com/forms/d/e/1FAIpQLSep4nbDf0G2UjzGF_S2e_w-dDYo3WJAR_0RxGK5rXwgtZblOQ/viewform?usp=pp_url" +
                                (info?.version != null
                                    ? "&entry.1581750442=${Uri.encodeQueryComponent(info.version)}"
                                    : ""),
                          );
                        },
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
                              decoration: InputDecoration(labelText: 'Adresse'),
                              controller: _urlController,
                              enabled: !widget.vm.loading,
                              keyboardType: TextInputType.url,
                            ),
                            Divider(),
                          ],
                          TextField(
                            // Remove this check when (if?) https://github.com/flutter/flutter/issues/67136 is resolved
                            autofillHints: widget.vm.loading
                                ? null
                                : [AutofillHints.username],
                            decoration:
                                InputDecoration(labelText: 'Benutzername'),
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
                              child: Text(
                                "Passwort vergessen",
                              ),
                              style: TextButton.styleFrom(
                                primary: Colors.grey,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                              ),
                              onPressed: widget.onRequestPassReset,
                            ),
                          ),
                          if (widget.vm.changePass) ...[
                            SizedBox(
                              height: 8,
                            ),
                            if (widget.vm.mustChangePass)
                              ListTile(
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
                              child: Text(
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
                              decoration:
                                  InputDecoration(labelText: 'Neues Passwort'),
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
                          SizedBox(height: 8),
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
                          Divider(),
                        ],
                      ),
                    ),
                  ),
                  SwitchListTile.adaptive(
                    title: Text("Angemeldet bleiben"),
                    subtitle:
                        Text("Deine Zugangsdaten werden lokal gespeichert"),
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
                    Divider(
                      height: 16,
                    ),
                    ListTile(
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
                                : widget.vm.error,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                .copyWith(color: Colors.red),
                          )
                        : SizedBox(),
                  ),
                ],
              ),
            ),
            if (widget.vm.loading) LinearProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
