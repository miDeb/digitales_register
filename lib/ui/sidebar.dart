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

import 'package:collapsible_sidebar/collapsible_sidebar.dart';
import 'package:collapsible_sidebar/collapsible_sidebar/collapsible_item.dart';
import 'package:dr/middleware/middleware.dart';
import 'package:flutter/material.dart';

import '../main.dart';

typedef SelectAccountCallback = void Function(int index);

class Sidebar extends StatelessWidget {
  const Sidebar({
    Key? key,
    required this.drawerExpanded,
    required this.onDrawerExpansionChange,
    required this.username,
    required this.userIcon,
    required this.tabletMode,
    required this.goHome,
    required this.currentSelected,
    required this.showGrades,
    required this.showAbsences,
    required this.showCalendar,
    required this.showCertificate,
    required this.showMessages,
    required this.showSettings,
    required this.logout,
    required this.otherAccounts,
    required this.selectAccount,
    required this.addAccount,
  }) : super(key: key);

  final DrawerCallback onDrawerExpansionChange;
  final VoidCallback goHome,
      showGrades,
      showAbsences,
      showCalendar,
      showCertificate,
      showMessages,
      showSettings,
      logout,
      addAccount;
  final bool tabletMode, drawerExpanded;
  final Pages currentSelected;
  final String? username, userIcon;
  final List<String> otherAccounts;
  final SelectAccountCallback selectAccount;

  @override
  Widget build(BuildContext context) {
    return CollapsibleSidebar(
      onExpansionChange: onDrawerExpansionChange,
      alwaysExpanded: !tabletMode,
      expanded: drawerExpanded,
      iconSize: 30,
      textStyle: Theme.of(context).textTheme.subtitle1,
      fitItemsToBottom: true,
      borderRadius: 0,
      minWidth: 70,
      screenPadding: 0,
      title: DropdownButtonHideUnderline(
        child: DropdownButton(
          isExpanded: true,
          value: 0,
          items: [
            for (var index = 0; index < otherAccounts.length + 2; index++)
              DropdownMenuItem(
                value: index,
                child: Text(
                  index == 0
                      ? (username ?? "?")
                      : index == otherAccounts.length + 1
                          ? "Account hinzufügen"
                          : otherAccounts[index - 1],
                ),
              ),
          ],
          onChanged: (int? value) {
            if (value == 0) {
              // selected the current account that is already selected
              // no-op
            } else {
              scaffoldKey?.currentState?.closeDrawerIfOpen();
              if (value == otherAccounts.length + 1) {
                addAccount();
              } else {
                selectAccount(value! - 1);
              }
            }
          },
        ),
      ),
      titleTooltip: username ?? "?",
      toggleTooltipCollapsed: "Ausklappen",
      toggleTooltipExpanded: "Einklappen",
      toggleTitle: const SizedBox(),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      avatar:
          //"https://vinzentinum.digitalesregister.it/v2/theme/icons/profile_empty.png" is the (ugly) default
          userIcon?.endsWith("/profile_empty.png") ?? true
              ? const Icon(Icons.account_circle)
              : Image.network(userIcon!),
      unselectedIconColor: Theme.of(context).iconTheme.color!,
      selectedIconColor: Theme.of(context).colorScheme.secondary,
      unselectedTextColor: Theme.of(context).textTheme.subtitle1!.color!,
      selectedTextColor: Theme.of(context).colorScheme.secondary,
      selectedIconBox: Theme.of(context).colorScheme.secondary.withAlpha(20),
      items: [
        if (tabletMode)
          CollapsibleItem(
            isSelected: currentSelected == Pages.homework,
            icon: Icons.assignment,
            text: "Hausaufgaben",
            onPressed: goHome,
          ),
        CollapsibleItem(
          onPressed: showGrades,
          isSelected: currentSelected == Pages.grades,
          text: "Noten",
          icon: Icons.grade,
        ),
        CollapsibleItem(
            text: "Absenzen",
            icon: Icons.hotel,
            isSelected: currentSelected == Pages.absences,
            onPressed: showAbsences),
        CollapsibleItem(
          text: "Kalender",
          icon: Icons.calendar_today,
          isSelected: currentSelected == Pages.calendar,
          onPressed: showCalendar,
        ),
        CollapsibleItem(
          text: "Zeugnis",
          icon: Icons.list,
          isSelected: currentSelected == Pages.certificate,
          onPressed: showCertificate,
        ),
        CollapsibleItem(
          text: "Mitteilungen",
          icon: Icons.message,
          isSelected: currentSelected == Pages.messages,
          onPressed: showMessages,
        ),
        CollapsibleItem(
          hasDivider: true,
          text: "Einstellungen",
          icon: Icons.settings,
          isSelected: currentSelected == Pages.settings,
          onPressed: showSettings,
        ),
        CollapsibleItem(
          hasDivider: true,
          text: "Abmelden",
          icon: Icons.logout,
          onPressed: logout,
        ),
      ],
      body: const SizedBox(),
    );
  }
}
