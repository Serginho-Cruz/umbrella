import 'package:flutter/widgets.dart';

import '../../../domain/entities/account.dart';
import '../texts/medium_text.dart';

class AccountName extends StatelessWidget {
  const AccountName({
    super.key,
    required this.account,
    required this.trailingText,
    this.alignment = MainAxisAlignment.spaceBetween,
  });

  final Account account;
  final String trailingText;
  final MainAxisAlignment alignment;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: alignment,
      children: [
        MediumText(trailingText),
        const SizedBox(width: 20.0),
        MediumText.bold(account.name),
      ],
    );
  }
}
