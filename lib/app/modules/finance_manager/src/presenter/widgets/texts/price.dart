import 'package:flutter/material.dart';
import '../../utils/currency_format.dart';
import '../../utils/umbrella_sizes.dart';

class Price extends StatelessWidget {
  final double value;
  final double? fontSize;
  final FontWeight fontWeight;

  const Price(
    this.value, {
    super.key,
    this.fontSize,
    this.fontWeight = FontWeight.normal,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      CurrencyFormat.format(value),
      style: TextStyle(fontSize: fontSize, fontWeight: fontWeight),
    );
  }

  const Price.small(
    this.value, {
    super.key,
    this.fontWeight = FontWeight.normal,
  }) : fontSize = UmbrellaSizes.small;

  const Price.medium(
    this.value, {
    super.key,
    this.fontWeight = FontWeight.normal,
  }) : fontSize = UmbrellaSizes.medium;

  const Price.big(
    this.value, {
    super.key,
    this.fontWeight = FontWeight.normal,
  }) : fontSize = UmbrellaSizes.big;

  const Price.extrabig(
    this.value, {
    super.key,
    this.fontWeight = FontWeight.normal,
  }) : fontSize = UmbrellaSizes.extrabig;

  const Price.title(
    this.value, {
    super.key,
    this.fontWeight = FontWeight.normal,
  }) : fontSize = UmbrellaSizes.title;
}
