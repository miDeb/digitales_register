import 'package:dr/container/notification_icon_container.dart';
import 'package:dr/middleware/middleware.dart';
import 'package:flutter/material.dart';
import 'package:responsive_scaffold/scaffold.dart';

import '../container/days_container.dart';
import '../container/drawer_buttons.dart';
import '../container/home_page.dart';
import '../main.dart';
import 'splash.dart';

class HomePageContent extends StatelessWidget {
  final HomePageContentViewModel vm;
  final VoidCallback refreshNoInternet;

  HomePageContent({Key key, this.vm, this.refreshNoInternet}) : super(key: key);
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
                    vm.noInternet && !vm.loading
                        ? FlatButton(
                            textColor: Theme.of(context).primaryIconTheme.color,
                            child: Row(
                              children: <Widget>[
                                Text("Kein Internet"),
                                SizedBox(width: 8),
                                Icon(Icons.refresh),
                              ],
                            ),
                            onPressed: refreshNoInternet,
                          )
                        : SizedBox(),
                    NotificationIconContainer(),
                  ],
                ),
                body: DaysContainer(),
              ),
              drawerBuilder: (selectWidget, goHome, currentSelected,
                      tabletMode) =>
                  vm.splash
                      ? null
                      : Column(
                          children: <Widget>[
                            UserAccountsDrawerHeader(
                              margin: EdgeInsets.zero,
                              currentAccountPicture: vm?.userIcon != null
                                  ? CircleAvatar(
                                      child: Image.network(vm.userIcon),
                                      backgroundColor: Colors.white70,
                                    )
                                  : null,
                              decoration: BoxDecoration(
                                  color: (Theme.of(context).appBarTheme.color ??
                                      Theme.of(context).primaryColor)),
                              accountEmail: Text("Digitales Register"),
                              accountName: Text(vm.username ?? "?",
                                  style: (Theme.of(context)
                                              .appBarTheme
                                              .textTheme ??
                                          Theme.of(context).primaryTextTheme)
                                      .headline5),
                            ),
                            Expanded(
                              child: Column(
                                children: <Widget>[
                                  if (tabletMode)
                                    Center(
                                      child: ListTile(
                                        selected:
                                            currentSelected == Pages.Homework,
                                        trailing: Icon(Icons.list),
                                        title: Text("Hausaufgabe"),
                                        onTap: goHome,
                                      ),
                                    ),
                                  Center(
                                    child: GradesButton(
                                      selected: currentSelected == Pages.Grades,
                                    ),
                                  ),
                                  Center(
                                    child: AbsencesButton(
                                      selected:
                                          currentSelected == Pages.Absences,
                                    ),
                                  ),
                                  Center(
                                    child: CalendarButton(
                                      selected:
                                          currentSelected == Pages.Calendar,
                                    ),
                                  ),
                                  Center(
                                    child: CertificateButton(
                                      selected:
                                          currentSelected == Pages.Certificate,
                                    ),
                                  ),
                                  Center(
                                    child: MessagesButton(
                                      selected:
                                          currentSelected == Pages.Messages,
                                    ),
                                  ),
                                  Spacer(),
                                  Center(
                                    child: SettingsButton(
                                      selected:
                                          currentSelected == Pages.Settings,
                                    ),
                                  ),
                                  Center(child: LogoutButton()),
                                ],
                              ),
                            )
                          ],
                        )),
        ),
      ),
    );
  }
}
