import 'package:flutter/material.dart';

import '../../../domain/entities/date.dart';
import '../texts/big_text.dart';

class PaymentRecordSection extends StatelessWidget {
  const PaymentRecordSection({
    super.key,
    required this.day,
    required this.children,
  });

  final Date day;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: BigText.bold('${day.day} de ${day.monthName}'),
      initiallyExpanded: true,
      children: children,
    );
  }
}
