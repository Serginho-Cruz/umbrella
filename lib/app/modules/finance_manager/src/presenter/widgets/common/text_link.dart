import 'package:flutter/material.dart';

import '../../../utils/umbrella_sizes.dart';

class TextLink extends StatelessWidget {
  const TextLink({super.key, required this.route, required this.text});

  final String route;
  final String text;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: UmbrellaSizes.medium,
          fontWeight: FontWeight.w900,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
