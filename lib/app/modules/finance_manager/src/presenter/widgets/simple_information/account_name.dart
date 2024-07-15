import 'package:flutter/widgets.dart';

import '../../../domain/entities/account.dart';
import '../texts/medium_text.dart';

class AccountName extends StatelessWidget {
  const AccountName({
    super.key,
    required this.account,
    required this.trailingText,
    this.alignment = MainAxisAlignment.spaceBetween,
    this.minimalSpace = 20.0,
  });

  final Account account;
  final String trailingText;
  final MainAxisAlignment alignment;
  final double minimalSpace;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: alignment,
      children: [
        MediumText(trailingText),
        SizedBox(width: minimalSpace),
        MediumText.bold(account.name),
      ],
    );
  }
}
