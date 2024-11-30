import 'package:flutter/material.dart';

abstract class UmbrellaButton extends StatelessWidget {
  const UmbrellaButton({
    super.key,
    required this.label,
    this.icon,
    required this.onPressed,
    required this.backgroundColor,
    required this.hoverColor,
    required this.highlightColor,
    required this.pressColor,
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
  final Color highlightColor;
  final Color pressColor;

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
        fixedSize: WidgetStatePropertyAll(Size(width, height)),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(vertical: 10.0),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        elevation: const WidgetStatePropertyAll(4.0),
        side: const WidgetStatePropertyAll(BorderSide(width: 1.0)),
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.hovered)) {
            return highlightColor;
          }
          return null;
        }),
        backgroundColor: WidgetStateProperty.resolveWith(
          (st) {
            return switch (st) {
              Set s when s.contains(WidgetState.hovered) => hoverColor,
              Set s when s.contains(WidgetState.pressed) => pressColor,
              _ => backgroundColor,
            };
          },
        ),
      ),
    );
  }
}
