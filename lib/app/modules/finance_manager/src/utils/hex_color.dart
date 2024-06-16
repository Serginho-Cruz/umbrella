import 'package:flutter/material.dart';

class HexColor extends Color {
  //See the opacity String on: https://davidwalsh.name/hex-opacity
  HexColor(String hexValue, [String opacity = 'FF'])
      : super(int.parse('0x$opacity$hexValue'));
}
