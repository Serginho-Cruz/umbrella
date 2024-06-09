import 'package:flutter/material.dart';
import '../../../utils/currency_format.dart';

class Price extends StatelessWidget {
  final double value;
  final double? fontSize;
  final FontWeight? fontWeight;

  const Price({
    super.key,
    required this.value,
    this.fontSize,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      CurrencyFormat.format(value),
      style: TextStyle(fontSize: fontSize, fontWeight: fontWeight),
    );
  }
}
