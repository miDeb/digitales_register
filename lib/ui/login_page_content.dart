import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tuple/tuple.dart';

import '../container/login_page.dart';
import '../util.dart';

typedef LoginCallback = void Function(String user, String pass, String url);
typedef ChangePassCallback = void Function(
    String user, String oldPass, String newPass, String url);
typedef SetSafeModeCallback = void Function(bool safeMode);

class LoginPageContent extends StatefulWidget {
  final LoginPageViewModel vm;
  final LoginCallback onLogin;
  final ChangePassCallback onChangePass;
  final SetSafeModeCallback setSaveNoPass;
  final VoidCallback onReload;
  final VoidCallback onRequestPassReset;

  LoginPageContent({
    Key key,
    @required this.vm,
    this.onLogin,
    this.setSaveNoPass,
    this.onReload,
    this.onChangePass,
    this.onRequestPassReset,
  }) : super(key: key);

  @override
  _LoginPageContentState createState() => _LoginPageContentState();
}

class _LoginPageContentState extends State<LoginPageContent> {
  final _usernameController = TextEditingController(),
      _passwordController = TextEditingController(),
      _newPassword1Controller = TextEditingController(),
      _newPassword2Controller = TextEditingController(),
      _urlController = TextEditingController.fromValue(
        TextEditingValue(
          text: "https://.digitalesregister.it",
          selection: TextSelection.fromPosition(
            // insert the caret at the subdomain position
            TextPosition(offset: 8),
          ),
        ),
      );
  bool safeMode;
  bool customUrl = false;
  bool urlFromVM = false;
  bool newPasswordsMatch = true;
  Tuple2<String, String> nonCustomServer;
  @override
  void initState() {
    safeMode = widget.vm.safeMode;
    nonCustomServer = widget.vm.servers.entries.first.toTuple();
    _usernameController.text = widget.vm.username;
    if (widget.vm.url != null && nonCustomServer.item2 != widget.vm.url) {
      _urlController.text = widget.vm.url;
      urlFromVM = true;
      customUrl = true;
      nonCustomServer = null;
    }
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
                  if (!widget.vm.changePass && !urlFromVM)
                    ListTile(
                      title: Text("Schule"),
                      trailing: DropdownButton(
                        items: widget.vm.servers.entries
                            .map(
                              (s) => DropdownMenuItem(
                                child: Text(s.key),
                                value: s.toTuple(),
                              ),
                            )
                            .toList()
                              ..add(
                                DropdownMenuItem(
                                  child: Text("Andere Schule"),
                                  value: null,
                                ),
                              ),
                        onChanged: (Tuple2 value) {
                          setState(() {
                            nonCustomServer = value;
                            // workaround: selection was not set anymore
                            if (value == null) {
                              _urlController.selection =
                                  TextSelection.fromPosition(
                                TextPosition(offset: 8),
                              );
                            }
                          });
                        },
                        value: nonCustomServer,
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: AutofillGroup(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (!widget.vm.changePass) ...[
                            if (nonCustomServer == null)
                              TextField(
                                decoration:
                                    InputDecoration(labelText: 'Adresse'),
                                controller: _urlController,
                                enabled: !widget.vm.loading,
                                autofocus: !urlFromVM,
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
                    subtitle: Text("Deine Zugangsdaten werden lokal gespeichert"),
                    value: !safeMode,
                    onChanged: widget.vm.loading
                        ? null
                        : (bool value) {
                            setState(() {
                              safeMode = !value;
                            });
                          },
                  ),
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
