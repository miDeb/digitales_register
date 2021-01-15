library collapsible_sidebar;

import 'dart:math' as math show pi;

import 'package:flutter/material.dart';
import 'package:collapsible_sidebar/collapsible_sidebar/collapsible_container.dart';
import 'package:collapsible_sidebar/collapsible_sidebar/collapsible_item.dart';
import 'package:collapsible_sidebar/collapsible_sidebar/collapsible_avatar.dart';
import 'package:collapsible_sidebar/collapsible_sidebar/collapsible_item_widget.dart';

export 'package:collapsible_sidebar/collapsible_sidebar/collapsible_item.dart';

typedef ExpansionChangeCallback = void Function(bool isExpanded);

class CollapsibleSidebar extends StatefulWidget {
  const CollapsibleSidebar({
    @required this.items,
    this.title,
    this.titleStyle,
    this.textStyle,
    this.toggleTitleStyle,
    this.toggleTitle = 'Collapse',
    this.avatar,
    this.height = double.infinity,
    this.minWidth = 80,
    this.maxWidth = 270,
    this.borderRadius = 15,
    this.iconSize = 40,
    this.toggleButtonIcon = Icons.chevron_right,
    this.backgroundColor = const Color(0xff2B3138),
    this.selectedIconBox = const Color(0xff2F4047),
    this.selectedIconColor = const Color(0xff4AC6EA),
    this.selectedTextColor = const Color(0xffF3F7F7),
    this.unselectedIconColor = const Color(0xff6A7886),
    this.unselectedTextColor = const Color(0xffC0C7D0),
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.fastLinearToSlowEaseIn,
    this.screenPadding = 4,
    this.showToggleButton = true,
    this.topPadding = 0,
    this.fitItemsToBottom = false,
    this.alwaysExpanded = false,
    this.initiallyExpanded = false,
    @required this.body,
    this.avatarSize,
    this.onExpansionChange,
  });

  final String title, toggleTitle;
  final TextStyle titleStyle, textStyle, toggleTitleStyle;
  final Widget body;
  final Widget avatar;
  final bool showToggleButton, fitItemsToBottom;
  final bool alwaysExpanded, initiallyExpanded;
  final List<CollapsibleItem> items;
  final double height,
      minWidth,
      maxWidth,
      borderRadius,
      iconSize,
      avatarSize,
      padding = 10,
      itemPadding = 10,
      topPadding,
      screenPadding;
  final IconData toggleButtonIcon;
  final Color backgroundColor,
      selectedIconBox,
      selectedIconColor,
      selectedTextColor,
      unselectedIconColor,
      unselectedTextColor;
  final Duration duration;
  final Curve curve;
  final ExpansionChangeCallback onExpansionChange;
  @override
  _CollapsibleSidebarState createState() => _CollapsibleSidebarState();
}

class _CollapsibleSidebarState extends State<CollapsibleSidebar>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _widthAnimation;
  CurvedAnimation _curvedAnimation;
  double tempWidth;

  bool __isCollapsed;

  set _isCollapsed(bool value) {
    if (value != __isCollapsed &&
        __isCollapsed != null &&
        widget.onExpansionChange != null) {
      widget.onExpansionChange(!value);
    }
    __isCollapsed = value;
  }

  bool get _isCollapsed {
    return __isCollapsed;
  }

  double _currWidth, _delta, _delta1By4, _delta3by4, _maxOffsetX;
  int _selectedItemIndex;

  CollapsibleItem getItemAt(int index) {
    if (index == null) {
      return null;
    }
    return widget.items[index];
  }

  @override
  void initState() {
    super.initState();

    tempWidth = widget.maxWidth > 270 ? 270 : widget.maxWidth;

    _currWidth = widget.minWidth;
    _delta = tempWidth - widget.minWidth;
    _delta1By4 = _delta * 0.25;
    _delta3by4 = _delta * 0.75;
    _maxOffsetX = widget.padding * 2 + widget.iconSize;
    for (var i = 0; i < widget.items.length; i++) {
      if (!widget.items[i].isSelected) continue;
      _selectedItemIndex = i;
      break;
    }

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _curvedAnimation = CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    );

    _controller.addListener(() {
      _currWidth = _widthAnimation.value;
      if (_controller.isCompleted) _isCollapsed = _currWidth == widget.minWidth;
      setState(() {});
    });

    _isCollapsed = !(widget.initiallyExpanded || widget.alwaysExpanded);

    if (widget.alwaysExpanded || widget.initiallyExpanded) {
      _animateTo(tempWidth);
      _controller.value = 1;
    }
  }

  void _animateTo(double endWidth) {
    _widthAnimation = Tween<double>(
      begin: _currWidth,
      end: endWidth,
    ).animate(_curvedAnimation);
    _controller.reset();
    _controller.forward();
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    _currWidth += details.primaryDelta;
    if (_currWidth > tempWidth)
      _currWidth = tempWidth;
    else if (_currWidth < widget.minWidth)
      _currWidth = widget.minWidth;
    else
      setState(() {});
  }

  void _onHorizontalDragEnd(DragEndDetails _) {
    if (_currWidth == tempWidth)
      setState(() => _isCollapsed = false);
    else if (_currWidth == widget.minWidth)
      setState(() => _isCollapsed = true);
    else {
      var threshold = _isCollapsed ? _delta1By4 : _delta3by4;
      var endWidth = _currWidth - widget.minWidth > threshold
          ? tempWidth
          : widget.minWidth;
      _animateTo(endWidth);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(widget.screenPadding),
      child: GestureDetector(
        onHorizontalDragUpdate:
            widget.alwaysExpanded ? null : _onHorizontalDragUpdate,
        onHorizontalDragEnd:
            widget.alwaysExpanded ? null : _onHorizontalDragEnd,
        child: CollapsibleContainer(
          height: widget.height,
          width: _currWidth,
          padding: widget.padding,
          borderRadius: widget.borderRadius,
          color: widget.backgroundColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.title != null) _avatar,
              SizedBox(
                height: widget.topPadding,
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: ListView(
                    shrinkWrap: true,
                    children: _items,
                    physics: BouncingScrollPhysics(),
                  ),
                ),
              ),
              if (widget.showToggleButton && !widget.alwaysExpanded) ...[
                Divider(
                  indent: 5,
                  endIndent: 5,
                ),
                _toggleButton,
              ]
            ],
          ),
        ),
      ),
    );
  }

  Widget get _avatar {
    return CollapsibleItemWidget(
      selected: false,
      padding: widget.itemPadding,
      offsetX: _offsetX,
      leading: CollapsibleAvatar(
        avatarSize: widget.iconSize,
        name: widget.title,
        avatar: widget.avatar,
        textStyle: _textStyle(widget.backgroundColor, widget.titleStyle),
      ),
      title: widget.title,
      textStyle: _textStyle(widget.unselectedTextColor, widget.titleStyle),
    );
  }

  List<Widget> get _items {
    return List.generate(widget.items.length, (index) {
      var item = getItemAt(index);
      var iconColor = widget.unselectedIconColor;
      var textColor = widget.unselectedTextColor;
      if (item.isSelected) {
        iconColor = widget.selectedIconColor;
        textColor = widget.selectedTextColor;
      }
      return CollapsibleItemWidget(
        duration: widget.duration,
        curve: widget.curve,
        hasDivider: item.hasDivider,
        selectedBoxColor: widget.selectedIconBox,
        selected: item.isSelected,
        padding: widget.itemPadding,
        offsetX: _offsetX,
        leading: Icon(
          item.icon,
          size: widget.iconSize,
          color: iconColor,
        ),
        title: item.text,
        textStyle: _textStyle(textColor, widget.textStyle),
        onTap: () {
          if (item.isSelected) return;
          item.onPressed();
          item.isSelected = true;
          getItemAt(_selectedItemIndex)?.isSelected = false;
          setState(() => _selectedItemIndex = index);
        },
      );
    });
  }

  Widget get _toggleButton {
    return CollapsibleItemWidget(
      selected: false,
      padding: widget.itemPadding,
      offsetX: _offsetX,
      leading: Transform.rotate(
        angle: _currAngle,
        child: Icon(
          widget.toggleButtonIcon,
          size: widget.iconSize,
          color: widget.unselectedIconColor,
        ),
      ),
      title: widget.toggleTitle,
      textStyle:
          _textStyle(widget.unselectedTextColor, widget.toggleTitleStyle),
      onTap: () {
        _isCollapsed = !_isCollapsed;
        var endWidth = _isCollapsed ? widget.minWidth : tempWidth;
        _animateTo(endWidth);
      },
    );
  }

  double get _fraction => (_currWidth - widget.minWidth) / _delta;
  double get _currAngle => -math.pi * _fraction;
  double get _offsetX => _maxOffsetX * _fraction;

  TextStyle _textStyle(Color color, TextStyle style) {
    return style == null
        ? TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: color,
          )
        : style.copyWith(color: color);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
