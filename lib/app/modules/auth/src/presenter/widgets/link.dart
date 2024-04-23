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
        // Navigator.pushNamed(widget.destinyRoute);
      },
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w900,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
