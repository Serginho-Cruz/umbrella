// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class HorizontallyInfinityContainer extends StatelessWidget {
  final Color color;
  final Widget? child;

  const HorizontallyInfinityContainer({
    super.key,
    this.color = Colors.white,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50.0),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          boxShadow: const [BoxShadow(blurRadius: 4.0, offset: Offset(0, 0))],
        ),
        padding: const EdgeInsets.only(
          top: 20.0,
        ),
        width: double.infinity,
        child: child,
      ),
    );
  }
}
