import 'package:flutter/material.dart';

class SpacedWidgets extends StatelessWidget {
  const SpacedWidgets({
    super.key,
    required this.first,
    required this.second,
    this.padding,
  });

  final Widget first;
  final Widget second;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          first,
          second,
        ],
      ),
    );
  }
}
