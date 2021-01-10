import 'package:flutter/material.dart';

class ChangeEmail extends StatefulWidget {
  final ChangeEmailCallback changeEmail;

  const ChangeEmail({Key key, this.changeEmail}) : super(key: key);
  @override
  _ChangeEmailState createState() => _ChangeEmailState();
}

typedef void ChangeEmailCallback(String pass, String email);

class _ChangeEmailState extends State<ChangeEmail> {
  final _passController = TextEditingController(),
      _emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Email-Adresse ändern"),
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
                decoration: InputDecoration(labelText: 'Aktuelles Passwort'),
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Neue Email-Adresse'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                child: Text("Speichern"),
                onPressed: () => widget.changeEmail(
                  _passController.text,
                  _emailController.text,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
