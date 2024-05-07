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
        animationDuration: const Duration(milliseconds: 500),
        elevation: const MaterialStatePropertyAll(6.0),
        shape: MaterialStatePropertyAll(
          RoundedRectangleBorder(
            side: const BorderSide(),
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        fixedSize: MaterialStatePropertyAll(size),
        backgroundColor: MaterialStateProperty.resolveWith(
          (states) {
            if (states.contains(MaterialState.pressed) ||
                states.contains(MaterialState.hovered)) {
              return const Color(0xFF6FDCFF);
            }

            return const Color(0xFFC786F9);
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
