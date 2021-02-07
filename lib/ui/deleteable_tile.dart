import 'package:flutter/material.dart';

class DeleteableTile extends StatelessWidget {
  final Widget child;
  final VoidCallback onDeleted;
  final double axisAlignment;

  const DeleteableTile({
    Key key,
    this.onDeleted,
    this.child,
    this.axisAlignment = 0,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Deleteable(
      builder: (context, onDelete) => Row(
        children: [
          Expanded(child: child),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () async {
              await onDelete();
              onDeleted();
            },
          )
        ],
      ),
    );
  }
}

typedef DeleteableBuilder = Widget Function(
  BuildContext context,
  FutureVoidCallback onDelete,
);

typedef FutureVoidCallback = Future<void> Function();

class Deleteable extends StatefulWidget {
  final DeleteableBuilder builder;
  final Duration duration;
  final double axisAlignment;

  const Deleteable({
    Key key,
    this.builder,
    this.duration = const Duration(milliseconds: 250),
    this.axisAlignment = 0,
  }) : super(key: key);
  @override
  _DeleteableState createState() => _DeleteableState();
}

class _DeleteableState extends State<Deleteable>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  @override
  void initState() {
    _controller = AnimationController(vsync: this, value: 0);
    _controller.animateTo(
      1,
      duration: widget.duration,
      curve: Curves.ease,
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: _controller,
      axisAlignment: widget.axisAlignment,
      child: widget.builder(context, () async {
        await _controller.animateTo(
          0,
          duration: widget.duration,
          curve: Curves.ease,
        );
      }),
    );
  }
}
