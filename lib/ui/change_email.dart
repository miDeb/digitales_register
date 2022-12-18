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

class ChangeEmail extends StatefulWidget {
  final ChangeEmailCallback changeEmail;

  const ChangeEmail({super.key, required this.changeEmail});
  @override
  _ChangeEmailState createState() => _ChangeEmailState();
}

typedef ChangeEmailCallback = void Function(String pass, String email);

class _ChangeEmailState extends State<ChangeEmail> {
  final _passController = TextEditingController(),
      _emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Email-Adresse ändern"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              TextField(
                obscureText: true,
                controller: _passController,
                decoration:
                    const InputDecoration(labelText: 'Aktuelles Passwort'),
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
                decoration:
                    const InputDecoration(labelText: 'Neue Email-Adresse'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => widget.changeEmail(
                  _passController.text,
                  _emailController.text,
                ),
                child: const Text("Speichern"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
