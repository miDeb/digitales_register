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

import 'package:dr/app_state.dart';
import 'package:dr/container/settings_page.dart';
import 'package:dr/ui/no_internet.dart';
import 'package:dr/ui/user_profile.dart';
import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  final ProfileState profileState;
  final bool noInternet;
  final OnSettingChanged<bool> setSendNotificationEmails;
  final VoidCallback changeEmail;
  final VoidCallback changePass;

  const Profile({
    Key? key,
    required this.profileState,
    required this.setSendNotificationEmails,
    required this.changeEmail,
    required this.changePass,
    required this.noInternet,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil"),
      ),
      body: profileState.name == null
          ? Center(
              child: noInternet
                  ? const NoInternet()
                  : const CircularProgressIndicator(),
            )
          : ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: UserProfile(
                    name: profileState.name!,
                    username: profileState.username!,
                    role: profileState.roleName!,
                  ),
                ),
                SwitchListTile.adaptive(
                  title: const Text("Emails für Benachrichtigungen senden"),
                  value: profileState.sendNotificationEmails!,
                  onChanged: noInternet ? null : setSendNotificationEmails,
                ),
                ListTile(
                  title: const Text("Email-Adresse ändern"),
                  subtitle: Text(profileState.email!),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: changeEmail,
                  enabled: !noInternet,
                ),
                ListTile(
                  title: const Text("Passwort ändern"),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: changePass,
                  enabled: !noInternet,
                ),
              ],
            ),
    );
  }
}
