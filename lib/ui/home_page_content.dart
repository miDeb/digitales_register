import 'package:flutter/material.dart';

import '../container/drawer_buttons.dart';
import '../container/home_page.dart';
import '../container/notification_icon.dart';
import 'days.dart';
import 'no_internet.dart';
import 'splash.dart';

class HomePageContent extends StatelessWidget {
  final HomePageContentViewModel vm;

  HomePageContent({Key key, this.vm}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: vm.splash
          ? null
          : AppBar(
              title: Text("Register"),
              actions: <Widget>[
                vm.noInternet && !vm.loading
                    ? InkWell(
                        child: Row(
                          children: <Widget>[
                            Text("Kein Internet"),
                            Icon(Icons.refresh),
                            SizedBox(
                              width: 16,
                            )
                          ],
                        ),
                        onTap: () {
                          vm.refreshNoInternet();
                        },
                      )
                    : SizedBox(),
                NotificationIcon(),
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
        child: HomePageContentBody(vm: vm),
        splash: vm.splash,
      ),
    );
  }
}

class HomePageContentBody extends StatelessWidget {
  final HomePageContentViewModel vm;

  const HomePageContentBody({Key key, @required this.vm}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (!vm.hasDays && vm.loading && !vm.noInternet) {
      return Center(child: CircularProgressIndicator());
    }
    final content = vm.hasDays
        ? RefreshIndicator(
            child: DaysWidget(),
            onRefresh: () async {
              vm.refresh();
              await Future.delayed(Duration(seconds: 2));
            },
          )
        : vm.noInternet
            ? Center(
                child: NoInternet(),
              )
            : Container();
    return vm.loading
        ? Stack(
            children: <Widget>[
              content,
              vm.hasDays
                  ? LinearProgressIndicator()
                  : CircularProgressIndicator(),
            ],
          )
        : content;
  }
}
