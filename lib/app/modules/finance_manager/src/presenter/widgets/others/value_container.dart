import 'package:flutter/material.dart';

import '../../../utils/umbrella_palette.dart';
import '../texts/medium_text.dart';

class ValueContainer extends StatelessWidget {
  const ValueContainer({
    super.key,
    required this.text,
    required this.valueWidget,
  });

  final String text;
  final Widget valueWidget;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45.0,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: UmbrellaPalette.secondaryColor,
        border: Border.all(),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          MediumText(text),
          const SizedBox(width: 20.0),
          valueWidget,
        ],
      ),
    );
  }
}
