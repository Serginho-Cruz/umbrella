import 'package:flutter/material.dart';

class HorizontallyInfinityContainer extends StatelessWidget {
  final Color color;
  final Widget? child;
  final bool noShadow;

  const HorizontallyInfinityContainer({
    super.key,
    this.color = Colors.white,
    this.child,
    this.noShadow = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50.0),
      child: Container(
        padding: const EdgeInsets.only(top: 20.0),
        decoration: BoxDecoration(
          color: color,
          boxShadow: noShadow
              ? null
              : const [BoxShadow(blurRadius: 4.0, offset: Offset(0, 0))],
        ),
        width: double.infinity,
        child: child,
      ),
    );
  }
}
