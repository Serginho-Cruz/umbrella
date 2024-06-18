import 'package:flutter/material.dart';

import '../../../utils/currency_format.dart';
import '../../../utils/umbrella_sizes.dart';

class RangeValueFilter extends StatelessWidget {
  const RangeValueFilter({
    super.key,
    required this.range,
    required this.min,
    required this.max,
    required this.onNewRange,
  });

  final RangeValues range;
  final double min;
  final double max;
  final void Function(RangeValues) onNewRange;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text.rich(
          TextSpan(
            style: const TextStyle(fontSize: UmbrellaSizes.medium),
            children: [
              const TextSpan(text: 'De '),
              TextSpan(
                text: CurrencyFormat.format(range.start),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const TextSpan(text: ' até '),
              TextSpan(
                text: CurrencyFormat.format(range.end),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          maxLines: 1,
        ),
        RangeSlider(
          values: range,
          min: min,
          max: max,
          onChanged: (newValues) {
            onNewRange(_roundTo10Divisor(newValues));
          },
        ),
      ],
    );
  }

  RangeValues _roundTo10Divisor(RangeValues range) {
    double min = range.start;
    double max = range.end;

    min = (min / 10).roundToDouble() * 10;
    max = (max / 10).roundToDouble() * 10;

    return RangeValues(min, max);
  }
}
