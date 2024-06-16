import 'package:flutter/material.dart';

sealed class UmbrellaPalette {
  static const Color primaryColor = Color(0xFFBF6DFF);
  static const Color secondaryColor = Color(0xFF6FDBFF);
  static const Color errorColor = Colors.red;
  static const Color successColor = Colors.green;
  static const Color actionButtonColor = primaryColor;
  static const Color secondaryButtonColor = secondaryColor;
  static const Color resetButtonColor = Colors.yellow;
  static const Color activePrimaryButton = Color(0xFFD7A3FF);
  static const Color activeSecondaryButton = Color(0xFFA8D8E8);
  static const Color activeResetButton = Color(0xFFC9B81A);
  static const List<Color> gradientColors = [
    Color(0xFF9BE4FF),
    Color(0xFFDAADFF),
  ];
  static const Color gray = Color(0xFFFAFAFA);
  static const List<(String, String)> cardHexAndNames = [
    ('FFFFFFFF', 'Branco'),
    ('FFBF6DFF', 'Roxo'),
    ('FFB2FF59', 'Verde Claro'),
    ('FF6FDBFF', 'Azul Claro'),
    ('FFFFFF00', 'Amarelo'),
    ('FFFF5252', 'Vermelho'),
  ];
}
