import 'package:dr/container/notification_icon_container.dart';
import 'package:flutter/material.dart';

import '../container/days_container.dart';
import '../container/drawer_buttons.dart';
import '../container/home_page.dart';
import 'splash.dart';

class HomePageContent extends StatelessWidget {
  final HomePageContentViewModel vm;
  final VoidCallback refreshNoInternet;

  HomePageContent({Key key, this.vm, this.refreshNoInternet}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: vm.splash
          ? null
          : AppBar(
              title: Text("Register"),
              actions: <Widget>[
                vm.noInternet && !vm.loading
                    ? FlatButton(
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
      drawer: vm.splash
          ? null
          : Drawer(
              child: Column(
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
                    accountName: Text(vm.userName ?? "?",
                        style: (Theme.of(context).appBarTheme.textTheme ??
                                Theme.of(context).primaryTextTheme)
                            .headline),
                  ),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Center(child: GradesButton()),
                        Center(child: AbsencesButton()),
                        Center(child: CalendarButton()),
                        Spacer(),
                        Center(child: SettingsButton()),
                        Center(child: LogoutButton()),
                      ],
                    ),
                  )
                ],
              ),
            ),
      body: SplashScreen(
        child: DaysContainer(),
        splash: vm.splash,
      ),
    );
  }
}
