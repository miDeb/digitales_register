import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tuple/tuple.dart';

import '../container/login_page.dart';
import '../util.dart';
import 'no_internet.dart';

typedef void LoginCallback(String user, String pass, String url);
typedef void SetSafeModeCallback(bool safeMode);

class LoginPageContent extends StatefulWidget {
  final LoginPageViewModel vm;
  final LoginCallback onLogin;
  final SetSafeModeCallback setSaveNoPass;
  final VoidCallback onReload;

  LoginPageContent({
    Key key,
    @required this.vm,
    this.onLogin,
    this.setSaveNoPass,
    this.onReload,
  }) : super(key: key);

  @override
  _LoginPageContentState createState() => _LoginPageContentState();
}

class _LoginPageContentState extends State<LoginPageContent> {
  final _usernameController = TextEditingController(),
      _passwordController = TextEditingController(),
      _urlController = TextEditingController.fromValue(
    TextEditingValue(
      text: "https://.digitalesregister.it",
      selection: TextSelection.fromPosition(
        TextPosition(offset: 8),
      ),
    ),
  );
  bool safeMode;
  bool customUrl = false;
  Tuple2<String, String> nonCustomServer;
  @override
  void initState() {
    safeMode = widget.vm.safeMode;
    nonCustomServer = widget.vm.servers.entries.first.toTuple();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Login"),
          automaticallyImplyLeading: false,
        ),
        body: widget.vm.noInternet
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    NoInternet(),
                    SizedBox(
                      height: 25,
                    ),
                    RaisedButton(
                      child: Text("Nochmal versuchen"),
                      onPressed: () => widget.onReload(),
                    ),
                  ],
                ),
              )
            : Stack(
                children: [
                  Center(
                    child: ListView(
                      shrinkWrap: true,
                      children: <Widget>[
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
                                      child: Text("Serveradresse eingeben"),
                                      value: null,
                                    ),
                                  ),
                            onChanged: (Tuple2 value) {
                              setState(() {
                                nonCustomServer = value;
                                // workaround: selection was not set anymore
                                if (value == null) {
                                  _urlController.selection = TextSelection.fromPosition(
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
                          child: Column(
                            children: [
                              if (nonCustomServer == null)
                                TextField(
                                  decoration: InputDecoration(labelText: 'Adresse'),
                                  controller: _urlController,
                                  enabled: !widget.vm.loading,
                                  autofocus: true,
                                  keyboardType: TextInputType.url,
                                ),
                              Divider(),
                              TextField(
                                decoration: InputDecoration(labelText: 'Username'),
                                controller: _usernameController,
                                enabled: !widget.vm.loading,
                              ),
                              TextField(
                                decoration: InputDecoration(labelText: 'Passwort'),
                                controller: _passwordController,
                                obscureText: true,
                                enabled: !widget.vm.loading,
                              ),
                              RaisedButton(
                                onPressed: widget.vm.loading
                                    ? null
                                    : () {
                                        widget.setSaveNoPass(safeMode);
                                        widget.onLogin(
                                          _usernameController.value.text,
                                          _passwordController.value.text,
                                          nonCustomServer?.item2 ?? _urlController.text,
                                        );
                                      },
                                child: Text('Login'),
                              ),
                              Divider(),
                            ],
                          ),
                        ),
                        SwitchListTile(
                          title: Text("Angemeldet bleiben"),
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
                                  widget.vm.error,
                                  style:
                                      Theme.of(context).textTheme.body1.copyWith(color: Colors.red),
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
