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
    return Scaffold(
      body: Center(
        child: Container(
          child: Image.asset("assets/transparent.png"),
          width: 200,
        ),
      ),
    );
  }
}
