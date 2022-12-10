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

class SplashScreen extends StatelessWidget {
  final Widget child;
  final bool splash;

  const SplashScreen({Key? key, required this.child, required this.splash})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    // We are using a stack here instead of an AnimatedCrossFade because the
    // latter results in errors, presumably because it does not size its hidden
    // children properly for this use-case.
    return Stack(
      children: [
        child,
        IgnorePointer(
          child: AnimatedOpacity(
            opacity: splash ? 1 : 0,
            duration: const Duration(milliseconds: 250),
            child: _SplashWidget(),
          ),
        ),
      ],
    );
  }
}

class _SplashWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final darkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Center(
        child: Image.asset(
          darkMode ? "assets/splash-dark.png" : "assets/splash-light.png",
        ),
      ),
    );
  }
}
