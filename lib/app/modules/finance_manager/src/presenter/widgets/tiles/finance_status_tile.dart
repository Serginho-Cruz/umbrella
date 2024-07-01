import 'package:flutter/material.dart';

import '../../../domain/models/status.dart';
import '../../utils/umbrella_palette.dart';
import '../icons/status_icon.dart';
import '../texts/small_text.dart';

class FinanceStatusTile extends StatelessWidget {
  const FinanceStatusTile({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: UmbrellaPalette.gradientColors),
        border: Border.all(width: 2.0),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(8.0),
          bottomRight: Radius.circular(8.0),
        ),
      ),
      child: ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
              Status.values.length, (i) => _buildStatus(Status.values[i])),
        ),
        enabled: false,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        shape: const Border(),
      ),
    );
  }

  Widget _buildStatus(Status status) {
    String name = switch (status) {
      Status.okay => 'Pago',
      Status.inTime => 'Em Tempo',
      Status.overdue => 'Vencido',
    };

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        StatusIcon(status: status, size: 35.0),
        const SizedBox(width: 8.0),
        SmallText.bold(name),
      ],
    );
  }
}
