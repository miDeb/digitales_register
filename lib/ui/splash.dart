import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  final Widget child;
  final bool splash;

  const SplashScreen({Key key, this.child, this.splash}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return splash ? _SplashWidget() : child;
  }
}

class _SplashWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Center(
        child: Image.asset("assets/index.png"),
      ),
    );
  }
}
