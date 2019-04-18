import 'package:flutter/material.dart';

import '../container/login_page.dart';
import 'no_internet.dart';

class LoginPageContent extends StatefulWidget {
  final LoginPageViewModel vm;

  LoginPageContent({Key key, @required this.vm}) : super(key: key);

  @override
  _LoginPageContentState createState() => _LoginPageContentState();
}

class _LoginPageContentState extends State<LoginPageContent> {
  final _usernameController = TextEditingController(),
      _passwordController = TextEditingController();
  bool safeMode;
  @override
  void initState() {
    safeMode = widget.vm.safeMode;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    onPressed: () => widget.vm.onReload(),
                  ),
                ],
              ),
            )
          : Stack(
              children: [
                Center(
                  child: ListView(
                    physics: AlwaysScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(children: [
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
                                    widget.vm.setSafeMode(safeMode);
                                    widget.vm.onLogin(
                                        _usernameController.value.text,
                                        _passwordController.value.text);
                                  },
                            child: Text('Login'),
                          ),
                          Divider(),
                        ]),
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
                                style: Theme.of(context)
                                    .textTheme
                                    .body1
                                    .copyWith(color: Colors.red),
                              )
                            : SizedBox(),
                      ),
                    ],
                  ),
                ),
                widget.vm.loading ? LinearProgressIndicator() : SizedBox(),
              ],
            ),
    );
  }
}
