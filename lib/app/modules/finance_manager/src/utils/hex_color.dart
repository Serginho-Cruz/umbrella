import 'package:flutter/material.dart';

class HexColor extends Color {
  HexColor(String hexValue) : super(int.parse('0xFF$hexValue'));
}
