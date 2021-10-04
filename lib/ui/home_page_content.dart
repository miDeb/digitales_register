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

import '../container/days_container.dart';
import '../container/home_page.dart';
import '../main.dart';
import 'splash.dart';

typedef DrawerCallback = void Function(bool isOpened);

class HomePageContent extends StatelessWidget {
  final HomePageContentViewModel vm;

  const HomePageContent({
    Key? key,
    required this.vm,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (nestedNavKey.currentState!.canPop()) {
          nestedNavKey.currentState!.pop();
          return Future.value(false);
        } else if (navigatorKey!.currentState!.canPop()) {
          navigatorKey!.currentState!.pop();
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
