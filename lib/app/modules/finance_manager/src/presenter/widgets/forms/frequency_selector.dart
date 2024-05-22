import 'package:flutter/material.dart';

import '../../../domain/entities/frequency.dart';
import '../../../utils/umbrella_sizes.dart';
import '../common/selectors.dart';
import '../common/spaced_widgets.dart';

class FrequencySelector extends StatelessWidget {
  const FrequencySelector({
    super.key,
    required this.onSelected,
    required this.selectedFrequency,
  });

  final void Function(Frequency) onSelected;
  final Frequency selectedFrequency;

  @override
  Widget build(BuildContext context) {
    return LinearSelector<Frequency>(
      items: Frequency.values,
      onItemTap: onSelected,
      title: const Padding(
        padding: EdgeInsets.only(top: 20.0, bottom: 25.0),
        child: Text(
          "Qual a Frequência da Despesa?",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: UmbrellaSizes.big),
        ),
      ),
      itemBuilder: (frequency) => Container(
        height: 50,
        padding: const EdgeInsets.fromLTRB(20.0, 10.0, 0, 10.0),
        child: Row(
          children: [
            Text(
              frequency.name,
              style: const TextStyle(
                fontSize: UmbrellaSizes.medium,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: SpacedWidgets(
          first: const Text(
            "Frequência",
            style: TextStyle(
              fontSize: UmbrellaSizes.big,
            ),
          ),
          second: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                selectedFrequency.name,
                style: const TextStyle(
                  fontSize: UmbrellaSizes.medium,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Icon(Icons.arrow_drop_down_rounded, size: 32.0)
            ],
          ),
        ),
      ),
    );
  }
}
