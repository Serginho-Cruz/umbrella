import 'package:flutter/material.dart';

import '../../../utils/umbrella_palette.dart';

class FilterButton extends StatelessWidget {
  const FilterButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: const Icon(Icons.filter_alt_outlined, color: Colors.white),
      iconSize: 30.0,
      style: ButtonStyle(
        fixedSize: const WidgetStatePropertyAll<Size>(Size(50, 50)),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: const BorderSide(),
          ),
        ),
        backgroundColor: WidgetStateProperty.resolveWith(
          (st) {
            if (st.any(
                (s) => s == WidgetState.pressed || s == WidgetState.hovered)) {
              return UmbrellaPalette.activePrimaryButton;
            }

            return UmbrellaPalette.actionButtonColor;
          },
        ),
      ),
    );
  }
}
