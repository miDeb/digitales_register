import 'package:flutter/material.dart';

/// A LinearProgressIndicator that animates when appearing and disappearing
class AnimatedLinearProgressIndicator extends StatefulWidget {
  final bool show;

  const AnimatedLinearProgressIndicator({
    Key? key,
    required this.show,
  }) : super(key: key);
  @override
  _AnimatedLinearProgressIndicatorState createState() =>
      _AnimatedLinearProgressIndicatorState();
}

class _AnimatedLinearProgressIndicatorState
    extends State<AnimatedLinearProgressIndicator>
    with SingleTickerProviderStateMixin {
  late final animation = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 150))
    ..addStatusListener(_animationStatusChanged);

  void _animationStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.dismissed) {
      setState(() {});
    }
  }

  void _updateShow() {
    if (widget.show && animation.isDismissed) {
      animation.forward();
    } else if (!widget.show && !animation.isDismissed) {
      animation.reverse();
    }
  }

  @override
  void initState() {
    super.initState();
    _updateShow();
  }

  @override
  void dispose() {
    animation.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(AnimatedLinearProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateShow();
  }

  @override
  Widget build(BuildContext context) {
    if (animation.isDismissed) {
      return const SizedBox();
    } else {
      return SizeTransition(
        sizeFactor: animation,
        child: FadeTransition(
          opacity: animation,
          child: const LinearProgressIndicator(),
        ),
      );
    }
  }
}
