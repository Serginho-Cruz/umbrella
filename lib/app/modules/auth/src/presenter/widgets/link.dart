import 'package:flutter/material.dart';

class Link extends StatelessWidget {
  const Link({
    super.key,
    required this.text,
    required this.destinyRoute,
  });

  final String text;
  final String destinyRoute;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacementNamed(context, destinyRoute);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w900,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }
}
