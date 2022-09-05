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

import 'package:flutter/material.dart';

class PassReset extends StatefulWidget {
  final ResetPass resetPass;
  final bool failure;
  final String? message;
  final VoidCallback onClose;

  const PassReset(
      {Key? key,
      required this.resetPass,
      required this.failure,
      this.message,
      required this.onClose})
      : super(key: key);
  @override
  _PassResetState createState() => _PassResetState();
}

typedef ResetPass = void Function(String newPass);

class _PassResetState extends State<PassReset> {
  final _newPass1Controller = TextEditingController(),
      _newPass2Controller = TextEditingController();
  @override
  void initState() {
    _newPass1Controller.addListener(() => setState(() {}));
    _newPass2Controller.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        widget.onClose();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Passwort zurücksetzen"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: AutofillGroup(
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
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
                    autofillHints: const [AutofillHints.newPassword],
                    controller: _newPass1Controller,
                    decoration:
                        const InputDecoration(labelText: 'Neues Passwort'),
                    obscureText: true,
                  ),
                  TextField(
                    autofillHints: const [AutofillHints.newPassword],
                    controller: _newPass2Controller,
                    decoration: InputDecoration(
                      labelText: 'Neues Passwort wiederholen',
                      errorText:
                          _newPass1Controller.text == _newPass2Controller.text
                              ? null
                              : "Die Passwörter stimmen noch nicht überein",
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  if (widget.message == null || widget.failure)
                    ElevatedButton(
                      onPressed: _newPass1Controller.text !=
                              _newPass2Controller.text
                          ? null
                          : () => widget.resetPass(_newPass1Controller.text),
                      child: const Text("Passwort zurücksetzen"),
                    ),
                  const SizedBox(height: 16),
                  if (widget.message != null)
                    Center(
                      child: Text(
                        widget.message!,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: widget.failure ? Colors.red : Colors.green),
                      ),
                    ),
                  if (widget.message != null && !widget.failure)
                    ElevatedButton(
                      onPressed: widget.onClose,
                      child: const Text("Ok"),
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
