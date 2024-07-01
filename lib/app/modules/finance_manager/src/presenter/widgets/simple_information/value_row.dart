import 'package:flutter/cupertino.dart';

import '../../utils/currency_format.dart';
import '../texts/medium_text.dart';

class ValueRow extends StatelessWidget {
  const ValueRow({
    super.key,
    this.alignment = MainAxisAlignment.start,
    required this.value,
    this.trailingText = 'Valor',
  });

  final String trailingText;
  final MainAxisAlignment alignment;
  final double value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: alignment,
      children: [
        MediumText(trailingText),
        const SizedBox(width: 20.0),
        MediumText.bold(CurrencyFormat.format(value)),
      ],
    );
  }
}
