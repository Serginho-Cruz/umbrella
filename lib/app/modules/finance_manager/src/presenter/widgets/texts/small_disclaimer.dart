import 'package:flutter/material.dart';

import '../../utils/umbrella_sizes.dart';

class SmallDisclaimer extends StatelessWidget {
  const SmallDisclaimer(
    this.data, {
    super.key,
    this.maxLines,
    this.textAlign,
    this.softWrap = false,
    this.fontWeight,
    this.fontStyle,
  });

  final String data;
  final int? maxLines;
  final TextAlign? textAlign;
  final FontStyle? fontStyle;

  final bool softWrap;
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    return Text(
      '*$data',
      textAlign: textAlign,
      softWrap: softWrap,
      style: TextStyle(
        fontSize: UmbrellaSizes.extrasmall,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
      ),
      overflow: TextOverflow.ellipsis,
      maxLines: maxLines,
    );
  }
}
