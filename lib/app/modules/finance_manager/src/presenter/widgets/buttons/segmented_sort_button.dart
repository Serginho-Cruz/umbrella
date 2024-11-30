import 'package:flutter/material.dart';

import '../texts/small_text.dart';

class SegmentedSortButton extends StatelessWidget {
  const SegmentedSortButton({
    super.key,
    required this.isCrescentOrder,
    required this.onChanged,
  });

  final bool isCrescentOrder;
  final void Function(bool) onChanged;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton(
      segments: const [
        ButtonSegment(
          value: true,
          label: SmallText('Mais Recentes'),
        ),
        ButtonSegment(
          value: false,
          label: SmallText('Mais Antigos'),
        ),
      ],
      selected: {isCrescentOrder},
      onSelectionChanged: (newOrder) {
        onChanged(newOrder.firstOrNull ?? true);
      },
    );
  }
}
