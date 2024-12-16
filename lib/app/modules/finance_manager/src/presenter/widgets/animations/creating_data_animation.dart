import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../texts/medium_text.dart';

class CreatingDataAnimation extends StatelessWidget {
  const CreatingDataAnimation({
    super.key,
    required this.width,
    required this.height,
    required this.message,
  });

  final double width;
  final double height;
  final String message;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Lottie.asset('assets/animations/create.json'),
          const SizedBox(height: 30),
          MediumText.bold(message),
        ],
      ),
    );
  }
}
