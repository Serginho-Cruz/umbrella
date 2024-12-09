import 'package:flutter/material.dart';
import '../../../domain/models/status.dart';
import '../../utils/umbrella_palette.dart';
import '../icons/status_icon.dart';
import '../texts/price.dart';
import '../layout/spaced.dart';

import '../../../domain/entities/date.dart';
import '../texts/big_text.dart';
import '../texts/small_text.dart';

abstract class FinanceCard extends StatelessWidget {
  final String name;
  final double totalValue;
  final double remainingValue;
  final Status status;
  final Date overdueDate;
  final Color valueColor;

  const FinanceCard({
    super.key,
    required this.name,
    required this.totalValue,
    required this.remainingValue,
    required this.status,
    required this.overdueDate,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 230,
          height: 180,
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.75),
                offset: Offset(2, 2),
                blurRadius: 4,
              )
            ],
            borderRadius: BorderRadius.circular(12.0),
            color: UmbrellaPalette.secondaryColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BigText.bold(name),
              Price.medium(
                totalValue,
                color: valueColor,
                fontWeight: FontWeight.w500,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Spaced(
                    first: const SmallText('Vencimento'),
                    second: SmallText(
                      overdueDate.toString(format: DateFormat.ddmmyyyy),
                    ),
                  ),
                  Spaced(
                    first: const SmallText('Pago'),
                    second: Price.small(totalValue - remainingValue),
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                  ),
                  Spaced(
                    first: const SmallText('Restante'),
                    second: Price.small(remainingValue),
                  )
                ],
              ),
            ],
          ),
        ),
        Positioned(
          top: 12,
          right: 12,
          child: StatusIcon(status: status, size: 28.0),
        ),
      ],
    );
  }
}
