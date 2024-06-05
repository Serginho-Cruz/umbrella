import 'package:flutter/material.dart';

sealed class UmbrellaPalette {
  static const Color primaryColor = Color(0xFFBF6DFF);
  static const Color secondaryColor = Color(0xFF6FDBFF);
  static const Color errorColor = Colors.red;
  static const Color successColor = Colors.green;
  static const Color actionButtonColor = primaryColor;
  static const Color secondaryButtonColor = secondaryColor;
  static const Color activePrimaryButton = Color(0xFFD7A3FF);
  static const Color activeSecondaryButton = Color(0xFFA8D8E8);
  static const Color gray = Color(0xFFFAFAFA);
  static const List<(String, String)> cardColorsHexAndNames = [
    ('FFFFFF', 'Branco'),
    ('BF6DFF', 'Roxo'), //Primary
    ('B2FF59', 'Verde Claro'),
    ('6FDBFF', 'Azul Claro'), //Secondary
    ('FFFF00', 'Amarelo'),
    ('FF5252', 'Vermelho'),
  ];
}
