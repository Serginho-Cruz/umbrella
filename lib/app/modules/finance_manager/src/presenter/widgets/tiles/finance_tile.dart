import 'package:flutter/material.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/texts/medium_text.dart';

import '../../../domain/entities/date.dart';
import '../../../domain/models/expense_model.dart';
import '../../../domain/models/finance_model.dart';
import '../../utils/umbrella_palette.dart';
import '../../utils/umbrella_sizes.dart';
import '../texts/price.dart';
import '../simple_information/category_row.dart';
import '../layout/spaced.dart';
import '../icons/status_icon.dart';
import '../texts/small_text.dart';

class FinanceTile extends StatelessWidget {
  const FinanceTile({
    super.key,
    required this.model,
    this.roundedOnTop = false,
    this.roundedOnBottom = false,
  });

  final FinanceModel model;
  final bool roundedOnTop;
  final bool roundedOnBottom;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      backgroundColor: UmbrellaPalette.secondaryColor,
      collapsedBackgroundColor: UmbrellaPalette.secondaryColor,
      leading: StatusIcon(status: model.status, size: 30.0),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MediumText.bold(
            model.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Price.medium(
            model.totalValue,
            fontWeight: FontWeight.bold,
          ),
        ],
      ),
      iconColor: Colors.black,
      collapsedIconColor: Colors.black,
      tilePadding: const EdgeInsets.symmetric(horizontal: 10.0),
      childrenPadding: const EdgeInsets.all(10.0),
      shape: _resolveBorder(roundedOnTop, roundedOnBottom),
      collapsedShape: _resolveBorder(roundedOnTop, roundedOnBottom),
      expansionAnimationStyle: AnimationStyle(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeIn,
        reverseCurve: Curves.easeOut,
      ),
      children: [
        Wrap(
          runSpacing: 12.0,
          children: [
            Spaced(
              first: const SmallText('Vencimento'),
              second: SmallText.bold(
                model.overdueDate.toString(format: DateFormat.ddmmyyyy),
              ),
            ),
            Spaced(
              first: const SmallText('Valor Pago'),
              second: Price.small(
                model.paidValue,
                fontWeight: FontWeight.bold,
              ),
            ),
            Spaced(
              first: const SmallText('Valor Restante'),
              second: Price.small(
                model.remainingValue,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (model.personName != null)
              Spaced(
                first: SmallText(
                  model is ExpenseModel ? 'Devedor' : 'Devo isso a',
                ),
                second: SmallText.bold(model.personName!),
              ),
            CategoryRow(
              category: model.category,
              iconSize: 30,
              textSize: UmbrellaSizes.small,
            ),
          ],
        ),
      ],
    );
  }

  ShapeBorder _resolveBorder(bool roundedOnTop, bool roundedOnBottom) {
    var radius = const Radius.circular(4.0);

    return RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: roundedOnTop ? radius : Radius.zero,
        topRight: roundedOnTop ? radius : Radius.zero,
        bottomLeft: roundedOnBottom ? radius : Radius.zero,
        bottomRight: roundedOnBottom ? radius : Radius.zero,
      ),
      side: _getBorderSide(),
    );
  }

  BorderSide _getBorderSide() => const BorderSide(width: 1.0);
}
