import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  final Widget child;
  final bool splash;

  const SplashScreen({Key key, this.child, this.splash}) : super(key: key);
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
            duration: Duration(milliseconds: 500),
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
