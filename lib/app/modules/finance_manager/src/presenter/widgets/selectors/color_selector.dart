import 'package:flutter/material.dart';

import '../../../utils/hex_color.dart';
import '../../../utils/umbrella_palette.dart';
import 'base_selectors.dart';

class ColorSelector extends StatelessWidget {
  const ColorSelector({
    super.key,
    required this.onSelected,
    required this.child,
  });

  ///Called when a color is selected. The parameter corresponds to the color's Hexadecimal
  ///and its name respectively.
  final void Function((String hex, String name)) onSelected;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GridSelector<(String, String)>(
      items: UmbrellaPalette.cardHexAndNames,
      itemSize: 75.0,
      linesGap: 20.0,
      onItemTap: onSelected,
      itemBuilder: (hexAndName) {
        return Container(
          width: 75.0,
          height: 75.0,
          decoration: BoxDecoration(
            border: Border.all(),
            color: HexColor(hexAndName.$1),
            shape: BoxShape.circle,
          ),
        );
      },
      child: child,
    );
  }
}
