import 'package:flutter/material.dart';

class SmallDisclaimer extends StatelessWidget {
  const SmallDisclaimer(
    this.data, {
    super.key,
    this.maxLines,
    this.textAlign,
    this.fontWeight,
  });

  final String data;
  final int? maxLines;
  final TextAlign? textAlign;
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    return Text(
      '*$data',
      textAlign: textAlign,
      style: TextStyle(
        fontSize: 14.0,
        fontWeight: fontWeight,
      ),
      overflow: TextOverflow.ellipsis,
      maxLines: maxLines,
    );
  }
}
