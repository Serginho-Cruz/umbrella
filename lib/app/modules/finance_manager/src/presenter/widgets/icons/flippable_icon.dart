import 'dart:math' show pi;

import 'package:flutter/material.dart';

import '../../utils/umbrella_palette.dart';

class FlippableIcon extends StatefulWidget {
  const FlippableIcon({
    super.key,
    this.initiallyFlipped = false,
    required this.radius,
    required this.render,
    this.onFlip,
  });

  final bool initiallyFlipped;
  final double radius;

  ///This callback is used to mount the icon when it's not selected
  final Widget Function(BuildContext) render;
  final void Function()? onFlip;

  @override
  State<FlippableIcon> createState() => _FlippableIconState();
}

class _FlippableIconState extends State<FlippableIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationStatus _status;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
      value: widget.initiallyFlipped ? 1.0 : 0.0,
    );

    _status = widget.initiallyFlipped
        ? AnimationStatus.completed
        : AnimationStatus.dismissed;

    _controller.addStatusListener((status) {
      _status = status;
    });

    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _flip,
      child: Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()
          ..setEntry(2, 1, 0.0015)
          ..rotateY(_controller.value * pi),
        child: _controller.value <= 0.5
            ? widget.render(context)
            : Container(
                width: widget.radius,
                height: widget.radius,
                decoration: const ShapeDecoration(
                  shape: CircleBorder(),
                  color: UmbrellaPalette.secondaryColor,
                ),
                child: Transform.flip(
                  flipX: true,
                  child: const Icon(Icons.check_rounded, size: 50.0),
                ),
              ),
      ),
    );
  }

  void _flip() {
    if (_status == AnimationStatus.dismissed) {
      _controller.forward();
    } else {
      _controller.reverse();
    }

    widget.onFlip?.call();
  }
}
