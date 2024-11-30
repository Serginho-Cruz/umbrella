import 'package:flutter/material.dart';

sealed class UmbrellaPalette {
  static const Color primaryColor = Color(0xFF9EFFA5);
  static const Color secondaryColor = Color(0xFFA7EAFF);
  static const Color errorColor = Colors.red;
  static const Color successColor = Colors.green;
  static const Color resetButtonColor = Colors.yellow;

  static const Color primaryButtonHoverColor = Color(0xFF8CEB93);
  static const Color primaryButtonPressColor = Color(0xFF76D580);
  static const Color primaryButtonHighlightColor = Color(0xFFB0FFC0);

  static const Color secondaryButtonColor = Color(0xFFFFD700);
  static const Color secondaryButtonHoverColor = Color(0xFFFFC400);
  static const Color secondaryButtonPressColor = Color(0xFFFFB200);
  static const Color secondaryButtonHighlightColor = Color(0xFFFFE58F);

  static const Color shimmerBaseColor = Color(0xFFBDBDBD);
  static const Color shimmerHighlightColor = Color(0xFFEEEEEE);
  static const Color negativeBalanceColor = Color(0xFFBF0000);
  static const Color gray = Color(0xFFFAFAFA);

  static const Color neutralValue = Colors.black;
  static const Color positiveValue = Color(0xFF1B5E20);
  static const Color negativeValue = Color(0xFFB71C1C);

  static const Color letterColor = Color(0xFFF5F5F5);
  static const Color letterBorderColor = Color(0xFF757575);

  static const List<Color> statusChartsColors = [
    Colors.indigo,
    Colors.pink,
    Colors.green,
    Colors.lightBlue,
    Colors.orange,
    Colors.purpleAccent,
    Colors.redAccent,
    Colors.cyan,
    Colors.yellow,
    Colors.brown,
    Colors.deepPurple,
    Colors.lime,
    Colors.teal,
  ];

  static const Color balanceChartLineColor = Colors.green;
  static const Color filtersColor = primaryButtonHoverColor;
  static const Color sliderFilterColor = Colors.green;

  static const Map<String, String> cardHexAndNames = {
    'FFFFFFFF': 'Branco',
    'FFBF6DFF': 'Roxo',
    'FFB2FF59': 'Verde Claro',
    'FF6FDBFF': 'Azul Claro',
    'FFFFFF00': 'Amarelo',
    'FFFF5252': 'Vermelho',
  };
}
