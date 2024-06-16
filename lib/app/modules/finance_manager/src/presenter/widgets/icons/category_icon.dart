import 'package:flutter/material.dart';

class CategoryIcon extends StatelessWidget {
  const CategoryIcon({
    super.key,
    required this.iconName,
    required this.radius,
  });

  final String iconName;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius,
      height: radius,
      decoration: BoxDecoration(
        border: Border.all(width: 2.0),
        shape: BoxShape.circle,
        image: DecorationImage(
          fit: BoxFit.cover,
          alignment: Alignment.center,
          image: AssetImage('assets/$iconName'),
        ),
      ),
    );
  }
}
