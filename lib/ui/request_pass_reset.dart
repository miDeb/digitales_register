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

typedef void ResetPass(String username, String email);

class _RequestPassResetState extends State<RequestPassReset> {
  final _usernameController = TextEditingController(),
      _emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Passwort vergessen"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: AutofillGroup(
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                TextField(
                  autofillHints: [AutofillHints.username],
                  controller: _usernameController,
                  decoration: InputDecoration(labelText: 'Benutzername'),
                ),
                TextField(
                  autofillHints: [AutofillHints.email],
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email-Adresse'),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  child: Text("Anfrage zum Zurücksetzen senden"),
                  onPressed: () => widget.resetPass(
                    _usernameController.text,
                    _emailController.text,
                  ),
                ),
                SizedBox(height: 16),
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
