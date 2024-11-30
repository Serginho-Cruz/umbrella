import 'package:flutter/material.dart';

import '../../../domain/usecases/filters/filter_payment_records.dart';
import '../texts/small_text.dart';
import 'umbrella_segmented_button.dart';

class SegmentedOriginButton extends StatelessWidget {
  const SegmentedOriginButton({
    super.key,
    this.selected,
    required this.onChanged,
  });

  final PaymentRecordType? selected;
  final void Function(PaymentRecordType? type) onChanged;

  @override
  Widget build(BuildContext context) {
    return UmbrellaSegmentedButton(
      segments: const [
        ButtonSegment(
          value: PaymentRecordType.income,
          label: SmallText('Receitas'),
        ),
        ButtonSegment(
          value: null,
          label: SmallText('Ambos'),
        ),
        ButtonSegment(
          value: PaymentRecordType.expense,
          label: SmallText('Despesas'),
        ),
      ],
      selected: {selected},
      onSelectionChanged: (types) {
        onChanged(types.firstOrNull);
      },
    );
  }
}
