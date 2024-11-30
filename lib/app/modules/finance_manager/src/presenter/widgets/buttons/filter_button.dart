import 'package:flutter/material.dart';

import '../../utils/umbrella_palette.dart';

class FilterButton extends StatelessWidget {
  const FilterButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: const Icon(Icons.filter_alt_rounded, color: Colors.black),
      iconSize: 30.0,
      style: ButtonStyle(
        fixedSize: const WidgetStatePropertyAll<Size>(Size(50, 50)),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: const BorderSide(),
          ),
        ),
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
