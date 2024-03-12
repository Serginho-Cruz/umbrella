import 'package:flutter/material.dart';

class ButtonWithIcon extends StatelessWidget {
  const ButtonWithIcon({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.color,
    required this.text,
    this.width,
  });

  final void Function() onPressed;
  final Icon icon;
  final Color color;
  final String text;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ButtonStyle(
        fixedSize: MaterialStatePropertyAll(
          Size(
            width ?? MediaQuery.of(context).size.width * 0.4,
            50.0,
          ),
        ),
        shape: MaterialStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
        ),
        padding: const MaterialStatePropertyAll(
          EdgeInsets.symmetric(vertical: 10.0),
        ),
        side: const MaterialStatePropertyAll(BorderSide(width: 1.0)),
        backgroundColor: MaterialStatePropertyAll(color),
        elevation: const MaterialStatePropertyAll(4.0),
      ),
      onPressed: onPressed,
      icon: icon,
      label: Text(
        text,
        style: const TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }
}
