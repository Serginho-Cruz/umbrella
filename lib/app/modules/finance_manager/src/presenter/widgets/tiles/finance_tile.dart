import 'package:flutter/material.dart';

import '../../../domain/entities/date.dart';
import '../../../domain/entities/payment_method.dart';
import '../../../domain/models/expense_model.dart';
import '../../../domain/models/finance_model.dart';
import '../../utils/umbrella_palette.dart';
import '../texts/big_text.dart';
import '../texts/medium_text.dart';
import '../texts/price.dart';
import 'category_row.dart';
import '../layout/spaced.dart';
import '../icons/status_icon.dart';

class FinanceTile extends StatelessWidget {
  const FinanceTile({
    super.key,
    required this.model,
    this.methodUsed,
    this.roundedOnTop = false,
  });

  final FinanceModel model;
  final PaymentMethod? methodUsed;
  final bool roundedOnTop;

  @override
  Widget build(BuildContext context) {
    var radius = const Radius.circular(8.0);
    var onTop = roundedOnTop;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: UmbrellaPalette.gradientColors),
        border: _getBorder(),
        borderRadius: BorderRadius.only(
          topLeft: onTop ? radius : Radius.zero,
          topRight: onTop ? radius : Radius.zero,
        ),
      ),
      child: ExpansionTile(
        leading: StatusIcon(status: model.status, size: 40.0),
        title: BigText.bold(
          model.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        iconColor: Colors.black,
        collapsedIconColor: Colors.black,
        subtitle: Price.medium(
          model.totalValue,
          fontWeight: FontWeight.bold,
        ),
        tilePadding: const EdgeInsets.symmetric(
          horizontal: 10.0,
          vertical: 4.0,
        ),
        childrenPadding: const EdgeInsets.all(10.0),
        shape: const Border(),
        collapsedShape: const Border(),
        expansionAnimationStyle: AnimationStyle(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeIn,
          reverseCurve: Curves.easeOut,
        ),
        children: [
          Wrap(
            runSpacing: 15.0,
            children: [
              Spaced(
                first: const MediumText('Vencimento'),
                second: MediumText.bold(
                  model.overdueDate.toString(format: DateFormat.ddmmyyyy),
                ),
              ),
              Spaced(
                first: const MediumText('Valor Pago'),
                second: Price.medium(
                  model.paidValue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spaced(
                first: const MediumText('Valor Restante'),
                second: Price.medium(
                  model.remainingValue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (model.personName != null)
                Spaced(
                  first: MediumText(
                    model is ExpenseModel ? 'Devedor' : 'Devo isso a',
                  ),
                  second: MediumText.bold(model.personName!),
                ),
            ],
          ),
          CategoryRow(category: model.category),
        ],
      ),
    );
  }

  BoxBorder _getBorder() {
    const side = BorderSide(width: 2.0);
    return const Border(left: side, right: side, top: side);
  }
}
