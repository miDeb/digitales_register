import 'dart:ui' as ui;
import 'package:collapsible_sidebar/collapsible_sidebar/unconstrained_overflow_widget.dart';
import 'package:flutter/material.dart';

class CollapsibleItemWidget extends StatelessWidget {
  const CollapsibleItemWidget({
    Key? key,
    required this.leading,
    required this.title,
    required this.tooltip,
    required this.textStyle,
    required this.padding,
    required this.offsetX,
    required this.selected,
    this.onTap,
    this.selectedBoxColor,
    this.hasDivider = false,
    this.curve,
  }) : super(key: key);

  final Widget leading;
  final Widget? title;
  final String tooltip;
  final TextStyle textStyle;
  final double offsetX, padding;
  final VoidCallback? onTap;
  final bool selected, hasDivider;
  final Color? selectedBoxColor;
  final Curve? curve;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        children: [
          if (hasDivider)
            const Divider(
              endIndent: 5,
              indent: 5,
            ),
          Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                bottom: 0,
                right: 0,
                child: AnimatedOpacity(
                  opacity: selected ? 1 : 0,
                  duration: const Duration(milliseconds: 1000),
                  curve: curve ?? Curves.linear,
                  child: Container(
                    decoration: BoxDecoration(
                      color: selectedBoxColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: onTap,
                child: ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return ui.Gradient.linear(
                      Offset(bounds.right - 10, 0),
                      Offset(bounds.right, 0),
                      [Colors.white, Colors.transparent],
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.all(padding),
                    child: UnconstrainedOverflowBox(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Tooltip(
                            child: leading,
                            message: tooltip,
                          ),
                          if (title != null)
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              width: 210,
                              child: DefaultTextStyle(
                                style: textStyle,
                                child: title!,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
