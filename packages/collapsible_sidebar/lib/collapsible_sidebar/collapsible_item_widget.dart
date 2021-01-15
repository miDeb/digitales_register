import 'package:collapsible_sidebar/collapsible_sidebar/unconstrained_overflow_widget.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class CollapsibleItemWidget extends StatelessWidget {
  const CollapsibleItemWidget({
    @required this.leading,
    @required this.title,
    @required this.textStyle,
    @required this.padding,
    @required this.offsetX,
    this.onTap,
    @required this.selected,
    this.selectedBoxColor,
    this.hasDivider = false,
    this.duration,
    this.curve,
  });

  final Widget leading;
  final String title;
  final TextStyle textStyle;
  final double offsetX, padding;
  final Function onTap;
  final bool selected, hasDivider;
  final Color selectedBoxColor;
  final Duration duration;
  final Curve curve;

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
            Divider(
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
                  duration: Duration(milliseconds: 1000),
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
                          leading,
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            width: 210,
                            child: Text(
                              title,
                              style: textStyle,
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
