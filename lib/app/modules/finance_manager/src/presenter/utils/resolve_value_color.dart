import 'package:flutter/material.dart';

import 'umbrella_palette.dart';

Color resolveValueColor(double value) => switch (value) {
      _ when value > 0.00 => UmbrellaPalette.incomeCardValueColor,
      _ when value < 0.00 => UmbrellaPalette.expenseCardValueColor,
      _ => Colors.black,
    };
