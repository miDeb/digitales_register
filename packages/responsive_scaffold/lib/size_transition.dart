// Like the SizeTransition widget from the flutter framework, except that it
// does not build its child if it is invisible.

import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Animates its own size and clips and aligns its child.
///
/// [SizeTransition] acts as a [ClipRect] that animates either its width or its
/// height, depending upon the value of [axis]. The alignment of the child along
/// the [axis] is specified by the [axisAlignment].
///
/// Like most widgets, [SizeTransition] will conform to the constraints it is
/// given, so be sure to put it in a context where it can change size. For
/// instance, if you place it into a [Container] with a fixed size, then the
/// [SizeTransition] will not be able to change size, and will appear to do
/// nothing.
///
/// Here's an illustration of the [SizeTransition] widget, with it's [sizeFactor]
/// animated by a [CurvedAnimation] set to [Curves.fastOutSlowIn]:
/// {@animation 300 378 https://flutter.github.io/assets-for-api-docs/assets/widgets/size_transition.mp4}
///
/// {@tool dartpad --template=stateful_widget_material_ticker}
///
/// This code defines a widget that uses [SizeTransition] to change the size
/// of [FlutterLogo] continually. It is built with a [Scaffold]
/// where the internal widget has space to change its size.
///
/// ```dart
/// late AnimationController _controller = AnimationController(
///   duration: const Duration(seconds: 3),
///   vsync: this,
/// )..repeat();
/// late Animation<double> _animation = CurvedAnimation(
///   parent: _controller,
///   curve: Curves.fastOutSlowIn,
/// );
///
/// @override
/// void dispose() {
///   super.dispose();
///   _controller.dispose();
/// }
///
/// @override
/// Widget build(BuildContext context) {
///   return Scaffold(
///     body: SizeTransition(
///       sizeFactor: _animation,
///       axis: Axis.horizontal,
///       axisAlignment: -1,
///       child: Center(
///           child: FlutterLogo(size: 200.0),
///       ),
///     ),
///   );
/// }
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [AnimatedCrossFade], for a widget that automatically animates between
///    the sizes of two children, fading between them.
///  * [ScaleTransition], a widget that scales the size of the child instead of
///    clipping it.
///  * [PositionedTransition], a widget that animates its child from a start
///    position to an end position over the lifetime of the animation.
///  * [RelativePositionedTransition], a widget that transitions its child's
///    position based on the value of a rectangle relative to a bounding box.
class SizeTransition extends AnimatedWidget {
  /// Creates a size transition.
  ///
  /// The [axis], [sizeFactor], and [axisAlignment] arguments must not be null.
  /// The [axis] argument defaults to [Axis.vertical]. The [axisAlignment]
  /// defaults to 0.0, which centers the child along the main axis during the
  /// transition.
  const SizeTransition({
    Key? key,
    this.axis = Axis.vertical,
    required Animation<double> sizeFactor,
    this.axisAlignment = 0.0,
    this.child,
  }) : super(key: key, listenable: sizeFactor);

  /// [Axis.horizontal] if [sizeFactor] modifies the width, otherwise
  /// [Axis.vertical].
  final Axis axis;

  /// The animation that controls the (clipped) size of the child.
  ///
  /// The width or height (depending on the [axis] value) of this widget will be
  /// its intrinsic width or height multiplied by [sizeFactor]'s value at the
  /// current point in the animation.
  ///
  /// If the value of [sizeFactor] is less than one, the child will be clipped
  /// in the appropriate axis.
  Animation<double> get sizeFactor => listenable as Animation<double>;

  /// Describes how to align the child along the axis that [sizeFactor] is
  /// modifying.
  ///
  /// A value of -1.0 indicates the top when [axis] is [Axis.vertical], and the
  /// start when [axis] is [Axis.horizontal]. The start is on the left when the
  /// text direction in effect is [TextDirection.ltr] and on the right when it
  /// is [TextDirection.rtl].
  ///
  /// A value of 1.0 indicates the bottom or end, depending upon the [axis].
  ///
  /// A value of 0.0 (the default) indicates the center for either [axis] value.
  final double axisAlignment;

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.ProxyWidget.child}
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final AlignmentDirectional alignment;
    if (axis == Axis.vertical) {
      alignment = AlignmentDirectional(-1.0, axisAlignment);
    } else {
      alignment = AlignmentDirectional(axisAlignment, -1.0);
    }
    return ClipRect(
      child: Align(
        alignment: alignment,
        heightFactor:
            axis == Axis.vertical ? math.max(sizeFactor.value, 0.0) : null,
        widthFactor:
            axis == Axis.horizontal ? math.max(sizeFactor.value, 0.0) : null,
        child: sizeFactor.value.abs() == 0 ? null : child,
      ),
    );
  }
}
