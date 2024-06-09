import 'package:flutter/material.dart';

import '../../../utils/umbrella_sizes.dart';

class MediumText extends StatelessWidget {
  final String data;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final FontWeight? fontWeight;
  final Color color;
  final TextDecoration? decoration;

  const MediumText(
    this.data, {
    super.key,
    this.maxLines,
    this.overflow,
    this.textAlign,
    this.textDirection,
    this.fontWeight,
    this.color = Colors.black,
    this.decoration,
  });

  const MediumText.light(
    this.data, {
    super.key,
    this.maxLines,
    this.overflow,
    this.textAlign,
    this.textDirection,
    this.color = Colors.black,
    this.decoration,
  }) : fontWeight = FontWeight.w300;

  const MediumText.bold(
    this.data, {
    super.key,
    this.maxLines,
    this.overflow,
    this.textAlign,
    this.textDirection,
    this.color = Colors.black,
    this.decoration,
  }) : fontWeight = FontWeight.bold;

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign,
      textDirection: textDirection,
      style: TextStyle(
        fontSize: UmbrellaSizes.medium,
        fontWeight: fontWeight,
        color: color,
        decoration: decoration,
      ),
    );
  }
}
