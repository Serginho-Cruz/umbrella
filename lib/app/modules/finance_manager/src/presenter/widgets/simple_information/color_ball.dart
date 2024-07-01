import 'package:flutter/widgets.dart';

import '../../utils/hex_color.dart';

class ColorBall extends StatelessWidget {
  const ColorBall({
    super.key,
    required this.hex,
  });

  final String hex;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.0,
      height: 40.0,
      decoration: BoxDecoration(
        border: Border.all(),
        color: HexColor(hex),
        shape: BoxShape.circle,
      ),
    );
  }
}
