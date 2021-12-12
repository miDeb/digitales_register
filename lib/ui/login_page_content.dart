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

import 'package:dr/l10n/l10n.dart' as l10n;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fuzzy/fuzzy.dart';
import 'package:tuple/tuple.dart';
import 'package:url_launcher/url_launcher.dart';

import '../container/login_page.dart';
import '../util.dart';
import 'animated_linear_progress_indicator.dart';

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

  String get url => nonCustomServer?.item2 ?? _urlController.text;

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
          title:
              Text(widget.vm.changePass ? l10n.changePassword() : l10n.login()),
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
                          enabled: !widget.vm.loading,
                          focusNode: _schoolFocusNode,
                          autofocus: _schoolController.text.isEmpty,
                          controller: _schoolController,
                          onChanged: (v) {
                            setState(() {
                              if (widget.vm.servers[v] == null) {
                                nonCustomServer = null;
                              } else {
                                nonCustomServer =
                                    Tuple2(v, widget.vm.servers[v]);
                                _urlController.text = nonCustomServer!.item2!;
                              }
                            });
                          },
                          decoration: InputDecoration(
                            labelText: l10n.school(),
                            errorText: !_schoolFocusNode.hasFocus &&
                                    _schoolController.text !=
                                        l10n.differentSchool() &&
                                    _schoolController.text.isNotEmpty &&
                                    nonCustomServer == null
                                ? l10n.schoolNotFound()
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
                            if (suggestion == l10n.differentSchool()) {
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
                          final candidates = [
                            ...Fuzzy(widget.vm.servers.keys.toList())
                                .search(pattern)
                                .map((e) => e.item),
                            l10n.differentSchool(),
                          ];
                          return candidates;
                        },
                        noItemsFoundBuilder: (context) {
                          return ListTile(
                            title: Text(
                              l10n.enterSchoolName(),
                              style: const TextStyle(color: Colors.grey),
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
                          launch(
                            // ignore: prefer_interpolation_to_compose_strings
                            "https://docs.google.com/forms/d/e/1FAIpQLSep4nbDf0G2UjzGF_S2e_w-dDYo3WJAR_0RxGK5rXwgtZblOQ/viewform?usp=pp_url" +
                                "&entry.1581750442=${Uri.encodeQueryComponent(appVersion)}",
                          );
                        },
                        child: Text(l10n.giveFeedback()),
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
                              decoration: InputDecoration(
                                labelText: l10n.address(),
                              ),
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
                            decoration: InputDecoration(
                              labelText: l10n.username(),
                            ),
                            controller: _usernameController,
                            enabled: !widget.vm.loading,
                          ),
                          TextField(
                            autofillHints: widget.vm.loading
                                ? null
                                : [AutofillHints.password],
                            decoration: InputDecoration(
                              labelText: widget.vm.changePass
                                  ? l10n.oldPassword()
                                  : l10n.password(),
                            ),
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
                              onPressed: () => widget.onRequestPassReset(url),
                              child: Text(
                                l10n.forgotPassword(),
                              ),
                            ),
                          ),
                          if (widget.vm.changePass) ...[
                            const SizedBox(
                              height: 8,
                            ),
                            if (widget.vm.mustChangePass)
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  l10n.forceChangePassword(),
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
                                l10n.passwordRequirements(),
                              ),
                            ),
                            TextField(
                              autofillHints: widget.vm.loading
                                  ? null
                                  : [AutofillHints.newPassword],
                              decoration: InputDecoration(
                                  labelText: l10n.newPassword()),
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
                                labelText: l10n.repeatNewPassword(),
                                errorText: newPasswordsMatch
                                    ? null
                                    : l10n.passwordsDontMatch(),
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
                                  ? l10n.changePassword()
                                  : l10n.login(),
                            ),
                          ),
                          const Divider(),
                        ],
                      ),
                    ),
                  ),
                  SwitchListTile.adaptive(
                    title: Text(l10n.stayLoggedIn()),
                    subtitle: Text(l10n.stayLoggedInDesc()),
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
                        l10n.otherAccounts(),
                        style: Theme.of(context).textTheme.headline6,
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
                        ? Text(
                            widget.vm.noInternet
                                ? l10n.connectionFailed(widget.vm.url!)
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
            AnimatedLinearProgressIndicator(show: widget.vm.loading),
          ],
        ),
      ),
    );
  }
}
