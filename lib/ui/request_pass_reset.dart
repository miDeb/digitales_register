import 'package:flutter/material.dart';

class RequestPassReset extends StatefulWidget {
  final ResetPass resetPass;
  final bool failure;
  final String message;

  const RequestPassReset({Key key, this.resetPass, this.failure, this.message})
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
        title: const Text("Passwort vergessen"),
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
                  decoration: const InputDecoration(labelText: 'Benutzername'),
                ),
                TextField(
                  autofillHints: const [AutofillHints.email],
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email-Adresse'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => widget.resetPass(
                    _usernameController.text,
                    _emailController.text,
                  ),
                  child: const Text("Anfrage zum Zurücksetzen senden"),
                ),
                const SizedBox(height: 16),
                if (widget.message != null)
                  Center(
                    child: Text(
                      widget.message,
                      style: Theme.of(context).textTheme.bodyText2.copyWith(
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
