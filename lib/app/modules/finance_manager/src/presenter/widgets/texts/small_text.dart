import 'package:flutter/material.dart';

import '../../utils/umbrella_sizes.dart';

class SmallText extends StatelessWidget {
  final String data;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final FontWeight? fontWeight;
  final Color color;
  final FontStyle? fontStyle;

  final bool softWrap;
  final TextDecoration? decoration;

  const SmallText(
    this.data, {
    super.key,
    this.maxLines,
    this.overflow,
    this.textAlign,
    this.textDirection,
    this.fontWeight,
    this.color = Colors.black,
    this.fontStyle,
    this.softWrap = true,
    this.decoration,
  });

  const SmallText.light(
    this.data, {
    super.key,
    this.maxLines,
    this.overflow,
    this.textAlign,
    this.textDirection,
    this.color = Colors.black,
    this.fontStyle,
    this.softWrap = true,
    this.decoration,
  }) : fontWeight = FontWeight.w300;

  const SmallText.bold(
    this.data, {
    super.key,
    this.maxLines,
    this.overflow,
    this.textAlign,
    this.textDirection,
    this.color = Colors.black,
    this.fontStyle,
    this.softWrap = true,
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
      softWrap: softWrap,
      style: TextStyle(
        fontSize: UmbrellaSizes.small,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        color: color,
        decoration: decoration,
      ),
    );
  }
}
