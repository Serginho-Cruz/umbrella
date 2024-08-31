import 'package:flutter/material.dart';

class BorderedIcon extends StatelessWidget {
  const BorderedIcon({
    super.key,
    required this.icon,
    required this.backgroundColor,
    this.iconColor = Colors.white,
    this.radius = 10.0,
  });

  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: backgroundColor,
      radius: radius,
      child: Icon(icon, color: iconColor, size: radius),
    );
  }
}
