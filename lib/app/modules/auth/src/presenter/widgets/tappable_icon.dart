import 'package:flutter/material.dart';

class TappableIcon extends StatelessWidget {
  const TappableIcon({super.key, required this.onTap, required this.icon});

  final VoidCallback onTap;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: icon,
    );
  }
}
