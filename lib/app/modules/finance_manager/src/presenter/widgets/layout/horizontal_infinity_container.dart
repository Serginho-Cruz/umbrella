import 'package:flutter/material.dart';

class HorizontallyInfinityContainer extends StatelessWidget {
  final Color color;
  final Widget? child;
  final bool noShadow;
  final EdgeInsetsGeometry padding;

  const HorizontallyInfinityContainer({
    super.key,
    this.color = Colors.white,
    this.child,
    this.noShadow = false,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        boxShadow: noShadow
            ? null
            : const [BoxShadow(blurRadius: 4.0, offset: Offset(0, 0))],
      ),
      width: double.infinity,
      child: child,
    );
  }
}
