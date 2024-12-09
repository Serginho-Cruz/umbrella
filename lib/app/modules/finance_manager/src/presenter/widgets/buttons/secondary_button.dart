import 'package:flutter/material.dart';

import '../../utils/umbrella_palette.dart';
import '../texts/medium_text.dart';
import 'umbrella_button.dart';

class SecondaryButton extends UmbrellaButton {
  const SecondaryButton({
    super.key,
    Widget? label,
    required super.onPressed,
    super.width,
    super.height,
    Icon? icon,
  }) : super(
          label: label ?? const MediumText.bold('Limpar'),
          icon: icon ??
              const Icon(
                Icons.refresh_rounded,
                size: 24.0,
                color: Colors.black,
              ),
          backgroundColor: UmbrellaPalette.secondaryButtonColor,
          hoverColor: UmbrellaPalette.secondaryButtonHoverColor,
          highlightColor: UmbrellaPalette.secondaryButtonHighlightColor,
          pressColor: UmbrellaPalette.secondaryButtonPressColor,
        );
}
