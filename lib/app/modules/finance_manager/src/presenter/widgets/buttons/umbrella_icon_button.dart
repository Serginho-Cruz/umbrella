import 'package:flutter/material.dart';

import '../../utils/umbrella_palette.dart';

class UmbrellaIconButton extends StatelessWidget {
  const UmbrellaIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    bool isPrimary = true,
  })  : backgroundColor = isPrimary
            ? UmbrellaPalette.primaryColor
            : UmbrellaPalette.secondaryButtonColor,
        hoverColor = isPrimary
            ? UmbrellaPalette.primaryButtonHoverColor
            : UmbrellaPalette.secondaryButtonHoverColor,
        highlightColor = isPrimary
            ? UmbrellaPalette.primaryButtonHighlightColor
            : UmbrellaPalette.secondaryButtonHighlightColor,
        pressColor = isPrimary
            ? UmbrellaPalette.primaryButtonPressColor
            : UmbrellaPalette.secondaryButtonPressColor;

  final Icon icon;
  final Color backgroundColor;
  final Color hoverColor;
  final Color highlightColor;
  final Color pressColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: icon,
      onPressed: onPressed,
      style: ButtonStyle(
        animationDuration: const Duration(milliseconds: 400),
        elevation: const WidgetStatePropertyAll(4.0),
        side: const WidgetStatePropertyAll(BorderSide(width: 1.0)),
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.hovered)) {
            return UmbrellaPalette.primaryButtonHighlightColor;
          }
          return null;
        }),
        backgroundColor: WidgetStateProperty.resolveWith(
          (st) {
            return switch (st) {
              Set s when s.contains(WidgetState.hovered) =>
                UmbrellaPalette.primaryButtonHoverColor,
              Set s when s.contains(WidgetState.pressed) =>
                UmbrellaPalette.primaryButtonPressColor,
              _ => UmbrellaPalette.primaryColor,
            };
          },
        ),
      ),
    );
  }
}
