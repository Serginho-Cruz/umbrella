import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  const AuthButton({
    super.key,
    required this.onPressed,
    required this.text,
    required this.size,
  });

  final void Function() onPressed;
  final String text;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: ButtonStyle(
        animationDuration: const Duration(milliseconds: 1000),
        elevation: const WidgetStatePropertyAll(6.0),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            side: const BorderSide(),
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        fixedSize: WidgetStatePropertyAll(size),
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.hovered)) {
            return const Color(0xFFB0FFC0);
          }
          return null;
        }),
        backgroundColor: WidgetStateProperty.resolveWith(
          (st) {
            return switch (st) {
              Set s when s.contains(WidgetState.hovered) =>
                const Color(0xFF8CEB93),
              Set s when s.contains(WidgetState.pressed) =>
                const Color(0xFF76D580),
              _ => const Color(0xFF9EFFA5),
            };
          },
        ),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18.0,
          color: Colors.black,
        ),
      ),
    );
  }
}
