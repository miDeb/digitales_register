import 'package:flutter/material.dart';

import '../container/days_container.dart';
import '../container/home_page.dart';
import '../main.dart';
import 'splash.dart';

typedef DrawerCallback = void Function(bool isOpened);

class HomePageContent extends StatelessWidget {
  final HomePageContentViewModel vm;

  const HomePageContent({
    Key key,
    this.vm,
  }) : super(key: key);
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
      child: SplashScreen(
        splash: vm.splash,
        child: DaysContainer(),
      ),
    );
  }
}
