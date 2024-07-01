import 'package:flutter/widgets.dart';

import 'color_ball.dart';
import '../layout/spaced.dart';
import '../texts/big_text.dart';

class ColorRow extends StatelessWidget {
  const ColorRow({
    super.key,
    required this.colorName,
    required this.colorHex,
    this.label = 'Cor',
    this.padding = EdgeInsets.zero,
  });

  final String label;
  final String colorName;
  final String colorHex;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Spaced(
      padding: padding,
      first: BigText(label),
      second: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          BigText(colorName),
          const SizedBox(width: 18.0),
          ColorBall(hex: colorHex),
        ],
      ),
    );
  }
}
