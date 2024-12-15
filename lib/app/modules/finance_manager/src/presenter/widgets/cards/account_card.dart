import 'package:flutter/material.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/utils/umbrella_sizes.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/icons/default_account_icon.dart';

import '../../../domain/entities/account.dart';
import '../../utils/currency_format.dart';
import '../../utils/resolve_value_color.dart';
import '../../utils/umbrella_palette.dart';
import '../texts/medium_text.dart';

class AccountCard extends StatelessWidget {
  const AccountCard({super.key, required this.account});

  final Account account;

  Widget _mountCard(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width * 0.6;
    return Container(
      width: width,
      height: 180,
      padding: const EdgeInsets.symmetric(
        vertical: 4,
        horizontal: 8,
      ),
      margin: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(4),
        color: UmbrellaPalette.secondaryColor,
        boxShadow: kElevationToShadow[2],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  MediumText.bold(account.name),
                  const SizedBox(height: 8),
                  Text.rich(
                    TextSpan(
                        style: const TextStyle(fontSize: UmbrellaSizes.small),
                        children: [
                          const TextSpan(text: 'Saldo: '),
                          TextSpan(
                            text: CurrencyFormat.format(account.actualBalance),
                            style: TextStyle(
                              color: resolveValueColor(account.actualBalance),
                            ),
                          ),
                        ]),
                  ),
                ],
              ),
              if (account.isDefault)
                const Tooltip(
                  message: 'Conta configurada como padrão',
                  child: DefaultAccountIcon(),
                ),
            ],
          ),
          ...List.generate(
            4,
            (i) => Align(
              alignment: Alignment.center,
              child: DecoratedBox(
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  color: Colors.black,
                ),
                child: SizedBox(height: 5, width: width - 40),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _mountCard(context);
  }
}
