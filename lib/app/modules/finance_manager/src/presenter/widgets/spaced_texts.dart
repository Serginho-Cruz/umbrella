import 'package:flutter/material.dart';

class SpacedTexts extends StatelessWidget {
  const SpacedTexts({
    super.key,
    required this.first,
    required this.second,
  });

  final Widget first;
  final Widget second;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        first,
        second,
      ],
    );
  }
}
