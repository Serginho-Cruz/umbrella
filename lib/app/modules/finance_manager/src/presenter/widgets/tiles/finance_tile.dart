import 'package:flutter/material.dart';

import '../../../domain/entities/date.dart';
import '../../../domain/entities/payment_method.dart';
import '../../../domain/models/expense_model.dart';
import '../../../domain/models/finance_model.dart';
import '../../../utils/umbrella_palette.dart';
import '../texts/big_text.dart';
import '../texts/medium_text.dart';
import '../texts/price.dart';
import 'category_row.dart';
import '../layout/spaced.dart';
import '../icons/status_icon.dart';

//TODO: Implement double tap detector. This action will open a menu with options. Like 'update', 'see in details'
class FinanceTile extends StatefulWidget {
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
  State<FinanceTile> createState() => _FinanceTileState();
}

class _FinanceTileState extends State<FinanceTile> {
  @override
  Widget build(BuildContext context) {
    var radius = const Radius.circular(8.0);

    var onTop = widget.roundedOnTop;

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
        leading: StatusIcon(status: widget.model.status, size: 40.0),
        title: BigText.bold(
          widget.model.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        iconColor: Colors.black,
        collapsedIconColor: Colors.black,
        subtitle: Price.medium(
          widget.model.totalValue,
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
                  widget.model.overdueDate
                      .toString(format: DateFormat.ddmmyyyy),
                ),
              ),
              Spaced(
                first: const MediumText('Valor Pago'),
                second: Price.medium(
                  widget.model.paidValue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spaced(
                first: const MediumText('Valor Restante'),
                second: Price.medium(
                  widget.model.remainingValue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (widget.model.personName != null)
                Spaced(
                  first: MediumText(
                    widget.model is ExpenseModel ? 'Devedor' : 'Devo isso a',
                  ),
                  second: MediumText.bold(widget.model.personName!),
                ),
            ],
          ),
          CategoryRow(category: widget.model.category),
        ],
      ),
    );
  }

  BoxBorder _getBorder() {
    const side = BorderSide(width: 2.0);
    return const Border(left: side, right: side, top: side);
  }
}
