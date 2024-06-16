import 'package:flutter/material.dart';

abstract class UmbrellaButton extends StatelessWidget {
  const UmbrellaButton({
    super.key,
    required this.label,
    this.icon,
    required this.onPressed,
    required this.backgroundColor,
    required this.hoverColor,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;
  final Widget label;
  final Widget? icon;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color hoverColor;

  @override
  Widget build(BuildContext context) {
    double width = this.width ?? MediaQuery.sizeOf(context).width * 0.4;
    double height = this.height ?? 50.0;
    return ElevatedButton.icon(
      label: label,
      icon: icon,
      onPressed: onPressed,
      style: ButtonStyle(
        animationDuration: const Duration(milliseconds: 400),
        fixedSize: MaterialStatePropertyAll(Size(width, height)),
        padding: const MaterialStatePropertyAll(
          EdgeInsets.symmetric(vertical: 10.0),
        ),
        shape: MaterialStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        elevation: const MaterialStatePropertyAll(4.0),
        side: const MaterialStatePropertyAll(BorderSide(width: 1.0)),
        backgroundColor: MaterialStateColor.resolveWith((states) {
          if (states.any((state) =>
              state == MaterialState.hovered ||
              state == MaterialState.pressed)) {
            return hoverColor;
          }

          return backgroundColor;
        }),
      ),
    );
  }
}
