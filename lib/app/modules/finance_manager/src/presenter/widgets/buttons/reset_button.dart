import 'package:flutter/material.dart';

import '../../utils/umbrella_palette.dart';
import '../texts/medium_text.dart';
import 'umbrella_button.dart';

class ResetButton extends UmbrellaButton {
  const ResetButton({
    super.key,
    Widget? label,
    required VoidCallback reset,
    super.width,
    super.height,
    Icon? icon,
  }) : super(
          onPressed: reset,
          label: label ?? const MediumText.bold('Limpar'),
          icon: icon ?? const Icon(Icons.refresh_rounded, size: 24.0),
          backgroundColor: UmbrellaPalette.resetButtonColor,
          hoverColor: UmbrellaPalette.activeResetButton,
        );
}
