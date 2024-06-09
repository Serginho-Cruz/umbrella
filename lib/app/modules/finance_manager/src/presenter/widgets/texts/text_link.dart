import 'package:flutter/material.dart';

import 'medium_text.dart';

class TextLink extends StatelessWidget {
  const TextLink({super.key, required this.route, required this.text});

  final String route;
  final String text;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: MediumText.bold(text, decoration: TextDecoration.underline),
    );
  }
}
