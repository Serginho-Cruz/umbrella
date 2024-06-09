import 'package:flutter/material.dart';

import '../../../domain/entities/frequency.dart';
import '../texts/big_text.dart';
import '../texts/medium_text.dart';
import 'base_selectors.dart';
import '../layout/spaced.dart';

class FrequencySelector extends StatelessWidget {
  const FrequencySelector({
    super.key,
    required this.onSelected,
    required this.selectedFrequency,
    required this.title,
  });

  final void Function(Frequency) onSelected;
  final Frequency selectedFrequency;
  final String title;

  @override
  Widget build(BuildContext context) {
    return LinearSelector<Frequency>(
      items: Frequency.values,
      onItemTap: onSelected,
      title: Padding(
        padding: const EdgeInsets.only(top: 20.0, bottom: 25.0),
        child: BigText(title, textAlign: TextAlign.center),
      ),
      itemBuilder: (frequency) => Container(
        height: 50,
        padding: const EdgeInsets.fromLTRB(20.0, 10.0, 0, 10.0),
        child: Row(
          children: [MediumText(frequency.name)],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Spaced(
          first: const BigText("Frequência"),
          second: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              MediumText.bold(selectedFrequency.name),
              const Icon(Icons.arrow_drop_down_rounded, size: 32.0)
            ],
          ),
        ),
      ),
    );
  }
}
