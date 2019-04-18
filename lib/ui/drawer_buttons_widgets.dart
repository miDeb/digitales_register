import 'package:flutter/material.dart';

import '../container/drawer_buttons.dart';

class LogoutButtonWidget extends StatelessWidget {
  final LogoutButtonViewModel vm;

  const LogoutButtonWidget({Key key, this.vm}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("Logout"),
      trailing: Icon(Icons.exit_to_app),
      onTap: vm.onLogout,
    );
  }
}
class SettingsButtonWidget extends StatelessWidget {
  final SettingsButtonViewModel vm;

  const SettingsButtonWidget({Key key, this.vm}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("Einstellungen"),
      trailing: Icon(Icons.settings),
      onTap: vm.onShowSettings,
    );
  }
}
class GradesButtonWidget extends StatelessWidget {
  final GradesButtonViewModel vm;

  const GradesButtonWidget({Key key, this.vm}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("Noten"),
      trailing: Icon(Icons.grade),
      onTap: vm.onShowGrades,
    );
  }
}
class AbsencesButtonWidget extends StatelessWidget {
  final AbsencesButtonViewModel vm;

  const AbsencesButtonWidget({Key key, this.vm}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("Absenzen"),
      trailing: Icon(Icons.hotel),
      onTap: vm.onShowAbsences,
    );
  }
}
class CalendarButtonWidget extends StatelessWidget {
  final CalendarButtonViewModel vm;

  const CalendarButtonWidget({Key key, this.vm}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("Kalender"),
      trailing: Icon(Icons.calendar_today),
      onTap: vm.onShowCalendar,
    );
  }
}
