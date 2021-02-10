import 'package:flutter/material.dart';

class ChangeEmail extends StatefulWidget {
  final ChangeEmailCallback changeEmail;

  const ChangeEmail({Key? key, required this.changeEmail}) : super(key: key);
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
