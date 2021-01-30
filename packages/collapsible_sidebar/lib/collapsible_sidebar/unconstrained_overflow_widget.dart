import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

// Copied from UnconstrainedBox and removed overflow debug indicators

/// A widget that imposes no constraints on its child, allowing it to render
/// at its "natural" size.
///
/// This allows a child to render at the size it would render if it were alone
/// on an infinite canvas with no constraints. This container will then attempt
/// to adopt the same size, within the limits of its own constraints. If it ends
/// up with a different size, it will align the child based on [alignment].
/// If the box cannot expand enough to accommodate the entire child, the
/// child will be clipped.
///
/// In debug mode, if the child overflows the container, a warning will be
/// printed on the console, and black and yellow striped areas will appear where
/// the overflow occurs.
///
/// See also:
///
///  * [ConstrainedBox], for a box which imposes constraints on its child.
///  * [Align], which loosens the constraints given to the child rather than
///    removing them entirely.
///  * [Container], a convenience widget that combines common painting,
///    positioning, and sizing widgets.
///  * [OverflowBox], a widget that imposes different constraints on its child
///    than it gets from its parent, possibly allowing the child to overflow
///    the parent.
class UnconstrainedOverflowBox extends SingleChildRenderObjectWidget {
  /// Creates a widget that imposes no constraints on its child, allowing it to
  /// render at its "natural" size. If the child overflows the parents
  /// constraints, a warning will be given in debug mode.
  const UnconstrainedOverflowBox({
    Key? key,
    Widget? child,
    this.textDirection,
    this.alignment = Alignment.center,
    this.constrainedAxis,
    this.clipBehavior = Clip.none,
  }) : super(key: key, child: child);

  /// The text direction to use when interpreting the [alignment] if it is an
  /// [AlignmentDirectional].
  final TextDirection? textDirection;

  /// The alignment to use when laying out the child.
  ///
  /// If this is an [AlignmentDirectional], then [textDirection] must not be
  /// null.
  ///
  /// See also:
  ///
  ///  * [Alignment] for non-[Directionality]-aware alignments.
  ///  * [AlignmentDirectional] for [Directionality]-aware alignments.
  final AlignmentGeometry alignment;

  /// The axis to retain constraints on, if any.
  ///
  /// If not set, or set to null (the default), neither axis will retain its
  /// constraints. If set to [Axis.vertical], then vertical constraints will
  /// be retained, and if set to [Axis.horizontal], then horizontal constraints
  /// will be retained.
  final Axis? constrainedAxis;

  /// {@macro flutter.material.Material.clipBehavior}
  ///
  /// Defaults to [Clip.none].
  final Clip clipBehavior;

  @override
  void updateRenderObject(BuildContext context,
      covariant RenderUnconstrainedOverflowBox renderObject) {
    renderObject
      ..textDirection = textDirection ?? Directionality.maybeOf(context)
      ..alignment = alignment
      ..constrainedAxis = constrainedAxis
      ..clipBehavior = clipBehavior;
  }

  @override
  RenderUnconstrainedOverflowBox createRenderObject(BuildContext context) =>
      RenderUnconstrainedOverflowBox(
        textDirection: textDirection ?? Directionality.maybeOf(context),
        alignment: alignment,
        constrainedAxis: constrainedAxis,
        clipBehavior: clipBehavior,
      );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(DiagnosticsProperty<AlignmentGeometry>('alignment', alignment));
    properties.add(EnumProperty<Axis>('constrainedAxis', constrainedAxis,
        defaultValue: null));
    properties.add(EnumProperty<TextDirection>('textDirection', textDirection,
        defaultValue: null));
  }
}

/// Renders a box, imposing no constraints on its child, allowing the child to
/// render at its "natural" size.
///
/// This allows a child to render at the size it would render if it were alone
/// on an infinite canvas with no constraints. This box will then attempt to
/// adopt the same size, within the limits of its own constraints. If it ends
/// up with a different size, it will align the child based on [alignment].
/// If the box cannot expand enough to accommodate the entire child, the
/// child will be clipped.
///
/// In debug mode, if the child overflows the box, a warning will be printed on
/// the console, and black and yellow striped areas will appear where the
/// overflow occurs.
///
/// See also:
///
///  * [RenderConstrainedBox], which renders a box which imposes constraints
///    on its child.
///  * [RenderConstrainedOverflowBox], which renders a box that imposes different
///    constraints on its child than it gets from its parent, possibly allowing
///    the child to overflow the parent.
///  * [RenderSizedOverflowBox], a render object that is a specific size but
///    passes its original constraints through to its child, which it allows to
///    overflow.
class RenderUnconstrainedOverflowBox extends RenderAligningShiftedBox {
  /// Create a render object that sizes itself to the child but does not
  /// pass the [constraints] down to that child.
  ///
  /// The [alignment] must not be null.
  RenderUnconstrainedOverflowBox({
    required AlignmentGeometry alignment,
    required TextDirection? textDirection,
    Axis? constrainedAxis,
    RenderBox? child,
    Clip clipBehavior = Clip.none,
  })  : _constrainedAxis = constrainedAxis,
        _clipBehavior = clipBehavior,
        super.mixin(alignment, textDirection, child);

  /// The axis to retain constraints on, if any.
  ///
  /// If not set, or set to null (the default), neither axis will retain its
  /// constraints. If set to [Axis.vertical], then vertical constraints will
  /// be retained, and if set to [Axis.horizontal], then horizontal constraints
  /// will be retained.
  Axis? get constrainedAxis => _constrainedAxis;
  Axis? _constrainedAxis;
  set constrainedAxis(Axis? value) {
    if (_constrainedAxis == value) return;
    _constrainedAxis = value;
    markNeedsLayout();
  }

  Rect _overflowContainerRect = Rect.zero;
  Rect _overflowChildRect = Rect.zero;
  bool _isOverflowing = false;

  /// {@macro flutter.material.Material.clipBehavior}
  ///
  /// Defaults to [Clip.none], and must not be null.
  Clip get clipBehavior => _clipBehavior;
  Clip _clipBehavior = Clip.none;
  set clipBehavior(Clip value) {
    if (value != _clipBehavior) {
      _clipBehavior = value;
      markNeedsPaint();
      markNeedsSemanticsUpdate();
    }
  }

  Size _calculateSizeWithChild(
      {required BoxConstraints constraints,
      required ChildLayouter layoutChild}) {
    assert(child != null);
    // Let the child lay itself out at it's "natural" size, but if
    // constrainedAxis is non-null, keep any constraints on that axis.
    late BoxConstraints childConstraints;
    switch (constrainedAxis) {
      case Axis.horizontal:
        childConstraints = BoxConstraints(
            maxWidth: constraints.maxWidth, minWidth: constraints.minWidth);
        break;
      case Axis.vertical:
        childConstraints = BoxConstraints(
            maxHeight: constraints.maxHeight, minHeight: constraints.minHeight);
        break;
      case null:
        childConstraints = const BoxConstraints();
        break;
    }
    return constraints.constrain(layoutChild(child!, childConstraints));
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    if (child == null) {
      return constraints.smallest;
    }
    return _calculateSizeWithChild(
      constraints: constraints,
      layoutChild: ChildLayoutHelper.dryLayoutChild,
    );
  }

  @override
  void performLayout() {
    final BoxConstraints constraints = this.constraints;
    if (child != null) {
      size = _calculateSizeWithChild(
        constraints: constraints,
        layoutChild: ChildLayoutHelper.layoutChild,
      );
      alignChild();
      final BoxParentData childParentData = child!.parentData as BoxParentData;
      _overflowContainerRect = Offset.zero & size;
      _overflowChildRect = childParentData.offset & child!.size;
    } else {
      size = constraints.smallest;
      _overflowContainerRect = Rect.zero;
      _overflowChildRect = Rect.zero;
    }
    _isOverflowing =
        RelativeRect.fromRect(_overflowContainerRect, _overflowChildRect)
            .hasInsets;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    // There's no point in drawing the child if we're empty, or there is no
    // child.
    if (child == null || size.isEmpty) return;

    if (!_isOverflowing) {
      super.paint(context, offset);
      return;
    }

    if (clipBehavior == Clip.none) {
      _clipRectLayer = null;
      super.paint(context, offset);
    } else {
      // We have overflow and the clipBehavior isn't none. Clip it.
      _clipRectLayer = context.pushClipRect(
          needsCompositing, offset, Offset.zero & size, super.paint,
          clipBehavior: clipBehavior, oldLayer: _clipRectLayer);
    }
  }

  ClipRectLayer? _clipRectLayer;

  @override
  Rect? describeApproximatePaintClip(RenderObject child) {
    return _isOverflowing ? Offset.zero & size : null;
  }

  @override
  String toStringShort() {
    String header = super.toStringShort();
    if (_isOverflowing) header += ' OVERFLOWING';
    return header;
  }
}
