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

class RequestPassReset extends StatefulWidget {
  final ResetPass resetPass;
  final bool failure;
  final String? message;

  const RequestPassReset(
      {Key? key, required this.resetPass, required this.failure, this.message})
      : super(key: key);
  @override
  _RequestPassResetState createState() => _RequestPassResetState();
}

typedef ResetPass = void Function(String username, String email);

class _RequestPassResetState extends State<RequestPassReset> {
  final _usernameController = TextEditingController(),
      _emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(l10n.forgotPassword()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: AutofillGroup(
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                TextField(
                  autofillHints: const [AutofillHints.username],
                  controller: _usernameController,
                  decoration: InputDecoration(labelText: l10n.username()),
                ),
                TextField(
                  autofillHints: const [AutofillHints.email],
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  decoration: InputDecoration(labelText: l10n.emailAddress()),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => widget.resetPass(
                    _usernameController.text,
                    _emailController.text,
                  ),
                  child:  Text(l10n.sendPassResetRequest()),
                ),
                const SizedBox(height: 16),
                if (widget.message != null)
                  Center(
                    child: Text(
                      widget.message!,
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(
                          color: widget.failure ? Colors.red : Colors.green),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
