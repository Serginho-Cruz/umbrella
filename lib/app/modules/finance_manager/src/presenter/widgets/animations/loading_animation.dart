import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../texts/medium_text.dart';

class LoadingAnimation extends StatelessWidget {
  const LoadingAnimation({
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
          Lottie.asset('assets/animations/loading.json', height: height - 60),
          const SizedBox(height: 30),
          MediumText.bold(message),
        ],
      ),
    );
  }
}
