import 'package:flutter/material.dart';

class CollapsibleItemWidget extends StatelessWidget {
  const CollapsibleItemWidget({
    @required this.leading,
    @required this.title,
    @required this.textStyle,
    @required this.padding,
    @required this.offsetX,
    @required this.scale,
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
  final double offsetX, scale, padding;
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
                child: Container(
                  color: Colors.transparent,
                  padding: EdgeInsets.all(padding),
                  child: Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      leading,
                      _title,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget get _title {
    return Opacity(
      opacity: scale,
      child: Transform.translate(
        offset: Offset(offsetX, 0),
        child: Transform.scale(
          scale: scale,
          child: SizedBox(
            width: double.infinity,
            child: Text(
              title,
              style: textStyle,
              softWrap: false,
              overflow: TextOverflow.fade,
            ),
          ),
        ),
      ),
    );
  }
}
