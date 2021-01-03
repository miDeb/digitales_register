import 'package:collapsible_sidebar/collapsible_sidebar.dart';
import 'package:dr/container/notification_icon_container.dart';
import 'package:dr/middleware/middleware.dart';
import 'package:flutter/material.dart';
import 'package:responsive_scaffold/scaffold.dart';

import '../container/days_container.dart';
import '../container/home_page.dart';
import '../main.dart';
import 'splash.dart';

typedef DrawerCallback = void Function(bool isOpened);

class HomePageContent extends StatelessWidget {
  final HomePageContentViewModel vm;
  final VoidCallback refreshNoInternet;
  final DrawerCallback onDrawerExpansionChange;

  final VoidCallback showGrades,
      showAbsences,
      showCalendar,
      showCertificate,
      showMessages,
      showSettings,
      logout;

  HomePageContent(
      {Key key,
      this.vm,
      this.refreshNoInternet,
      this.showGrades,
      this.showAbsences,
      this.showCalendar,
      this.showCertificate,
      this.showMessages,
      this.showSettings,
      this.logout,
      this.onDrawerExpansionChange})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (nestedNavKey.currentState.canPop()) {
          nestedNavKey.currentState.pop();
          return Future.value(false);
        } else if (navigatorKey.currentState.canPop()) {
          navigatorKey.currentState.pop();
          return Future.value(false);
        }
        return Future.value(true);
      },
      child: Scaffold(
        body: SplashScreen(
          splash: vm.splash,
          child: ResponsiveScaffold<Pages>(
            navKey: nestedNavKey,
            homeId: Pages.Homework,
            key: scaffoldKey,
            home: Scaffold(
              appBar: ResponsiveAppBar(
                isHomePage: true,
                title: Text("Register"),
                actions: <Widget>[
                  if (vm.noInternet && !vm.loading)
                    FlatButton(
                      textColor: Theme.of(context).primaryIconTheme.color,
                      child: Row(
                        children: <Widget>[
                          Text("Kein Internet"),
                          SizedBox(width: 8),
                          Icon(Icons.refresh),
                        ],
                      ),
                      onPressed: refreshNoInternet,
                    ),
                  NotificationIconContainer(),
                ],
              ),
              body: DaysContainer(),
            ),
            drawerBuilder: (selectWidget, goHome, currentSelected, tabletMode) {
              if (vm.splash) {
                return null;
              }
              return CollapsibleSidebar(
                onExpansionChange: onDrawerExpansionChange,
                alwaysExpanded: !tabletMode,
                initiallyExpanded: vm.drawerInitiallyFullyExpanded,
                iconSize: 30,
                textStyle: Theme.of(context).textTheme.subtitle1,
                fitItemsToBottom: true,
                borderRadius: 0,
                minWidth: 70,
                screenPadding: 0,
                title: vm.username ?? "?",
                toggleTitle: "",
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                avatar:
                    //"https://vinzentinum.digitalesregister.it/v2/theme/icons/profile_empty.png" is the (ugly) default
                    vm.userIcon?.endsWith("/profile_empty.png") != false
                        ? Icon(Icons.account_circle)
                        : Image.network(vm.userIcon),
                unselectedIconColor: Theme.of(context).iconTheme.color,
                selectedIconColor: Theme.of(context).accentColor,
                unselectedTextColor:
                    Theme.of(context).textTheme.subtitle1.color,
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
            },
          ),
        ),
      ),
    );
  }
}
