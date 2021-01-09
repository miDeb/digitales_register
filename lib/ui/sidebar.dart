import 'package:collapsible_sidebar/collapsible_sidebar.dart';
import 'package:collapsible_sidebar/collapsible_sidebar/collapsible_item.dart';
import 'package:dr/middleware/middleware.dart';
import 'package:flutter/material.dart';


class Sidebar extends StatelessWidget {
  const Sidebar({
    Key key,
    @required this.drawerInitiallyFullyExpanded,
    @required this.onDrawerExpansionChange,
    @required this.username,
    @required this.userIcon,
    @required this.tabletMode,
    @required this.goHome,
    @required this.currentSelected,
    @required this.showGrades,
    @required this.showAbsences,
    @required this.showCalendar,
    @required this.showCertificate,
    @required this.showMessages,
    @required this.showSettings,
    @required this.logout,
  }) : super(key: key);

  final DrawerCallback onDrawerExpansionChange;
  final VoidCallback goHome,
      showGrades,
      showAbsences,
      showCalendar,
      showCertificate,
      showMessages,
      showSettings,
      logout;
  final bool tabletMode, drawerInitiallyFullyExpanded;
  final Pages currentSelected;
  final String username, userIcon;

  @override
  Widget build(BuildContext context) {
    return CollapsibleSidebar(
      onExpansionChange: onDrawerExpansionChange,
      alwaysExpanded: !tabletMode,
      initiallyExpanded: drawerInitiallyFullyExpanded,
      iconSize: 30,
      textStyle: Theme.of(context).textTheme.subtitle1,
      fitItemsToBottom: true,
      borderRadius: 0,
      minWidth: 70,
      screenPadding: 0,
      title: username ?? "?",
      toggleTitle: "",
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      avatar:
          //"https://vinzentinum.digitalesregister.it/v2/theme/icons/profile_empty.png" is the (ugly) default
          userIcon?.endsWith("/profile_empty.png") != false
              ? Icon(Icons.account_circle)
              : Image.network(userIcon),
      unselectedIconColor: Theme.of(context).iconTheme.color,
      selectedIconColor: Theme.of(context).accentColor,
      unselectedTextColor: Theme.of(context).textTheme.subtitle1.color,
      selectedTextColor: Theme.of(context).accentColor,
      selectedIconBox: Theme.of(context).accentColor.withAlpha(20),
      items: [
        if (tabletMode)
          CollapsibleItem(
            isSelected: currentSelected == Pages.Homework,
            icon: Icons.assignment,
            text: "Hausaufgabe",
            onPressed: goHome,
          ),
        CollapsibleItem(
          onPressed: showGrades,
          isSelected: currentSelected == Pages.Grades,
          text: "Noten",
          icon: Icons.grade,
        ),
        CollapsibleItem(
            text: "Absenzen",
            icon: Icons.hotel,
            isSelected: currentSelected == Pages.Absences,
            onPressed: showAbsences),
        CollapsibleItem(
          text: "Kalender",
          icon: Icons.calendar_today,
          isSelected: currentSelected == Pages.Calendar,
          onPressed: showCalendar,
        ),
        CollapsibleItem(
          text: "Zeugnis",
          icon: Icons.list,
          isSelected: currentSelected == Pages.Certificate,
          onPressed: showCertificate,
        ),
        CollapsibleItem(
          text: "Mitteilungen",
          icon: Icons.message,
          isSelected: currentSelected == Pages.Messages,
          onPressed: showMessages,
        ),
        CollapsibleItem(
          hasDivider: true,
          text: "Einstellungen",
          icon: Icons.settings,
          isSelected: currentSelected == Pages.Settings,
          onPressed: showSettings,
        ),
        CollapsibleItem(
          hasDivider: true,
          text: "Abmelden",
          icon: Icons.logout,
          onPressed: logout,
        ),
      ],
      body: SizedBox(),
    );
  }
}
