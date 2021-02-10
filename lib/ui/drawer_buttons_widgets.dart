import 'package:flutter/material.dart';

class LogoutButtonWidget extends StatelessWidget {
  final VoidCallback onLogout;

  const LogoutButtonWidget({Key? key, required this.onLogout})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text("Logout"),
      trailing: const Icon(Icons.exit_to_app),
      onTap: () {
        onLogout();
      },
    );
  }
}

class SettingsButtonWidget extends StatelessWidget {
  final bool selected;
  final VoidCallback onShowSettings;

  const SettingsButtonWidget(
      {Key? key, required this.onShowSettings, required this.selected})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      selected: selected,
      title: const Text("Einstellungen"),
      trailing: const Icon(Icons.settings),
      onTap: () {
        onShowSettings();
      },
    );
  }
}

class GradesButtonWidget extends StatelessWidget {
  final bool selected;
  final VoidCallback onShowGrades;

  const GradesButtonWidget(
      {Key? key, required this.onShowGrades, required this.selected})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      selected: selected,
      title: const Text("Noten"),
      trailing: const Icon(Icons.grade),
      onTap: () {
        onShowGrades();
      },
    );
  }
}

class AbsencesButtonWidget extends StatelessWidget {
  final bool selected;
  final VoidCallback onShowAbsences;

  const AbsencesButtonWidget(
      {Key? key, required this.onShowAbsences, required this.selected})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      selected: selected,
      title: const Text("Absenzen"),
      trailing: const Icon(Icons.hotel),
      onTap: () {
        onShowAbsences();
      },
    );
  }
}

class CalendarButtonWidget extends StatelessWidget {
  final bool selected;
  final VoidCallback onShowCalendar;

  const CalendarButtonWidget(
      {Key? key, required this.onShowCalendar, required this.selected})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      selected: selected,
      title: const Text("Kalender"),
      trailing: const Icon(Icons.calendar_today),
      onTap: () {
        onShowCalendar();
      },
    );
  }
}

class CertificateButtonWidget extends StatelessWidget {
  final bool selected;
  final VoidCallback onShowCertificate;

  const CertificateButtonWidget(
      {Key? key, required this.onShowCertificate, required this.selected})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      selected: selected,
      title: const Text("Zeugnis"),
      trailing: const Icon(Icons.list),
      onTap: () {
        onShowCertificate();
      },
    );
  }
}

class MessagesButtonWidget extends StatelessWidget {
  final bool selected;
  final VoidCallback onShowMessages;

  const MessagesButtonWidget(
      {Key? key, required this.onShowMessages, required this.selected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      selected: selected,
      title: const Text("Mitteilungen"),
      trailing: const Icon(Icons.message),
      onTap: () {
        onShowMessages();
      },
    );
  }
}
