import 'package:flutter/material.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/utils/umbrella_palette.dart';
import 'dart:math' show pi;

import '../../../domain/entities/category.dart';
import '../texts/medium_text.dart';
import 'category_icon.dart';

class FlippableCategoryIcon extends StatefulWidget {
  const FlippableCategoryIcon({
    super.key,
    this.onFlip,
    required this.category,
    this.initiallyFlipped = false,
  });

  final Category category;
  final bool initiallyFlipped;
  final VoidCallback? onFlip;

  @override
  State<FlippableCategoryIcon> createState() => _FlippableCategoryIconState();
}

class _FlippableCategoryIconState extends State<FlippableCategoryIcon>
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(2, 1, 0.0015)
              ..rotateY(_controller.value * pi),
            child: _controller.value <= 0.5
                ? CategoryIcon(iconName: widget.category.icon, radius: 70.0)
                : Container(
                    width: 70.0,
                    height: 70.0,
                    decoration: const ShapeDecoration(
                      shape: CircleBorder(),
                      gradient: RadialGradient(
                        colors: UmbrellaPalette.gradientColors,
                      ),
                    ),
                    child: Transform.flip(
                      flipX: true,
                      child: const Icon(Icons.check_rounded, size: 50.0),
                    ),
                  ),
          ),
          const SizedBox(height: 10.0),
          MediumText(widget.category.name),
        ],
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
