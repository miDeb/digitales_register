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
