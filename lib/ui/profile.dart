import 'package:flutter/material.dart';

import '../app_state.dart';
import '../container/settings_page.dart';
import 'no_internet.dart';
import 'user_profile.dart';

class Profile extends StatelessWidget {
  final ProfileState profileState;
  final bool noInternet;
  final OnSettingChanged<bool> setSendNotificationEmails;
  final VoidCallback changeEmail;
  final VoidCallback changePass;

  const Profile({
    Key key,
    this.profileState,
    this.setSendNotificationEmails,
    this.changeEmail,
    this.changePass,
    this.noInternet,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil"),
      ),
      body: profileState == null
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
                    name: profileState.name,
                    username: profileState.username,
                    role: profileState.roleName,
                  ),
                ),
                SwitchListTile.adaptive(
                  title: const Text("Emails für Benachrichtigungen senden"),
                  value: profileState.sendNotificationEmails,
                  onChanged: noInternet ? null : setSendNotificationEmails,
                ),
                ListTile(
                  title: const Text("Email-Adresse ändern"),
                  subtitle: Text(profileState.email),
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
