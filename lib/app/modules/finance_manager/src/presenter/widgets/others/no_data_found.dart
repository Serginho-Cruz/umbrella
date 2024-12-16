import 'package:flutter/material.dart';

import '../texts/medium_text.dart';

class NoDataFound extends StatelessWidget {
  const NoDataFound({
    super.key,
    required this.width,
    required this.message,
    required this.tooltipMessage,
  });

  final double width;
  final String message;
  final String tooltipMessage;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltipMessage,
      child: SizedBox(
        width: width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/no_data_found.png',
              fit: BoxFit.fitWidth,
            ),
            const SizedBox(height: 20.0),
            MediumText.bold(message, textAlign: TextAlign.center, maxLines: 2),
          ],
        ),
      ),
    );
  }
}
