import 'package:flutter/material.dart';

import '../../../domain/entities/expense.dart';
import '../../../domain/entities/income.dart';
import '../../../domain/entities/invoice.dart';
import '../../../domain/entities/paiyable.dart';
import '../../../domain/entities/payment_record.dart';
import '../../utils/resolve_value_color.dart';
import '../../utils/umbrella_palette.dart';
import '../icons/payment_method_icon.dart';
import '../texts/extrasmall_text.dart';
import '../texts/price.dart';
import '../texts/small_text.dart';

class PaymentRecordWidget extends StatelessWidget {
  const PaymentRecordWidget({
    super.key,
    required this.record,
    this.roundedOnTop = true,
    this.roundedOnBottom = true,
  });

  final PaymentRecord record;
  final bool roundedOnTop;
  final bool roundedOnBottom;

  @override
  Widget build(BuildContext context) {
    var value = record.paiyable is Income ? record.value : -record.value;

    return ListTile(
      tileColor: UmbrellaPalette.secondaryColor.withOpacity(0.8),
      contentPadding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
      shape: _resolveBorder(),
      title: SmallText.bold(_resolvePaiyableOriginName(record.paiyable)),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _mountPaymentMethodRow(),
            const SizedBox(height: 6),
            _mountAccountRow(),
          ],
        ),
      ),
      trailing: Price.small(value, color: resolveValueColor(value)),
    );
  }

  ShapeBorder _resolveBorder() {
    const radius = Radius.circular(8.0);
    const zero = Radius.zero;

    return RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: roundedOnTop ? radius : zero,
        topRight: roundedOnTop ? radius : zero,
        bottomLeft: roundedOnBottom ? radius : zero,
        bottomRight: roundedOnBottom ? radius : zero,
      ),
      side: const BorderSide(),
    );
  }

  Widget _mountPaymentMethodRow() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const ExtrasmallText('Pago utilizando:'),
        const SizedBox(width: 8),
        ExtrasmallText(record.paymentMethod.name),
        const SizedBox(width: 8),
        PaymentMethodIcon(
          dimension: 20,
          method: record.paymentMethod,
          withBorder: false,
        ),
      ],
    );
  }

  Widget _mountAccountRow() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const ExtrasmallText('Conta usada:'),
        const SizedBox(width: 8),
        ExtrasmallText(record.usedAccount.name),
      ],
    );
  }

  String _resolvePaiyableOriginName(Paiyable paiyable) {
    return switch (paiyable) {
      Income i => i.name,
      Expense e => e.name,
      Invoice inv => 'Fatura ${inv.card.name}',
      _ => 'Origem desconhecida pelo app',
    };
  }
}
