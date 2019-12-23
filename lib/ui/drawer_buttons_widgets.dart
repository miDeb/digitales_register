import 'package:flutter/material.dart';

class LogoutButtonWidget extends StatelessWidget {
  final VoidCallback onLogout;

  const LogoutButtonWidget({Key key, this.onLogout}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("Logout"),
      trailing: Icon(Icons.exit_to_app),
      onTap: onLogout,
    );
  }
}

class SettingsButtonWidget extends StatelessWidget {
  final VoidCallback onShowSettings;

  const SettingsButtonWidget({Key key, this.onShowSettings}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("Einstellungen"),
      trailing: Icon(Icons.settings),
      onTap: onShowSettings,
    );
  }
}

class GradesButtonWidget extends StatelessWidget {
  final VoidCallback onShowGrades;

  const GradesButtonWidget({Key key, this.onShowGrades}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("Noten"),
      trailing: Icon(Icons.grade),
      onTap: onShowGrades,
    );
  }
}

class AbsencesButtonWidget extends StatelessWidget {
  final VoidCallback onShowAbsences;

  const AbsencesButtonWidget({Key key, this.onShowAbsences}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("Absenzen"),
      trailing: Icon(Icons.hotel),
      onTap: onShowAbsences,
    );
  }
}

class CalendarButtonWidget extends StatelessWidget {
  final VoidCallback onShowCalendar;

  const CalendarButtonWidget({Key key, this.onShowCalendar}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("Kalender"),
      trailing: Icon(Icons.calendar_today),
      onTap: onShowCalendar,
    );
  }
}
