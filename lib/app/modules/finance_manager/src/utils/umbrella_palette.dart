import 'package:flutter/material.dart';

sealed class UmbrellaPalette {
  static const Color primaryColor = Color(0xFFBF6DFF);
  static const Color secondaryColor = Color(0xFF6FDBFF);
  static const Color errorColor = Colors.red;
  static const Color successColor = Colors.green;
  static const Color actionButtonColor = primaryColor;
  static const Color secondaryButtonColor = secondaryColor;
  static const Color activePrimaryButton = Color.fromARGB(255, 215, 163, 255);
  static const Color activeSecondaryButton = Color.fromARGB(255, 168, 216, 232);
  static const Color gray = Color(0xFFFAFAFA);
  static const List<Color> cardColors = [];
}
