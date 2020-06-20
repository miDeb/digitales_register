import 'package:flutter/material.dart';

class PassReset extends StatefulWidget {
  final ResetPass resetPass;
  final bool failure;
  final String message;
  final VoidCallback onClose;

  const PassReset(
      {Key key, this.resetPass, this.failure, this.message, this.onClose})
      : super(key: key);
  @override
  _PassResetState createState() => _PassResetState();
}

typedef void ResetPass(String newPass);

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
          title: Text("Passwort zurücksetzen"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
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
                  child: Text(
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
                  controller: _newPass1Controller,
                  decoration: InputDecoration(labelText: 'Neues Passwort'),
                  obscureText: true,
                ),
                TextField(
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
                SizedBox(
                  height: 16,
                ),
                if (widget.message == null || widget.failure)
                  RaisedButton(
                    child: Text("Passwort zurücksetzen"),
                    onPressed:
                        _newPass1Controller.text != _newPass2Controller.text
                            ? null
                            : () => widget.resetPass(_newPass1Controller.text),
                  ),
                SizedBox(height: 16),
                if (widget.message != null)
                  Center(
                    child: Text(
                      widget.message,
                      style: Theme.of(context).textTheme.bodyText2.copyWith(
                          color: widget.failure ? Colors.red : Colors.green),
                    ),
                  ),
                if (widget.message != null && !widget.failure)
                  RaisedButton(
                    child: Text("Ok"),
                    onPressed: widget.onClose,
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
