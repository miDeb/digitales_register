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
