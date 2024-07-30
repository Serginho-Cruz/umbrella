import 'package:flutter/material.dart';

import '../../utils/umbrella_palette.dart';

class UmbrellaIconButton extends StatelessWidget {
  const UmbrellaIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    bool isPrimary = true,
  })  : backgroundColor = isPrimary
            ? UmbrellaPalette.actionButtonColor
            : UmbrellaPalette.secondaryButtonColor,
        hoverColor = isPrimary
            ? UmbrellaPalette.activePrimaryButton
            : UmbrellaPalette.activeSecondaryButton;

  final Icon icon;
  final Color backgroundColor;
  final Color hoverColor;
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
        backgroundColor: WidgetStateColor.resolveWith((states) {
          if (states.any((state) =>
              state == WidgetState.hovered || state == WidgetState.pressed)) {
            return hoverColor;
          }

          return backgroundColor;
        }),
      ),
    );
  }
}
