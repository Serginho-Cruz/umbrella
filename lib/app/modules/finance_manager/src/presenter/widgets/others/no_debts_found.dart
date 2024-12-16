import 'package:flutter/material.dart';

import '../texts/medium_text.dart';

class NoDebtsFound extends StatelessWidget {
  const NoDebtsFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Você não fez dívidas com ninguém ainda. Continue assim!',
      child: SizedBox(
        width: MediaQuery.sizeOf(context).width * 0.8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/no_debts_found.png',
              fit: BoxFit.fitWidth,
            ),
            const SizedBox(height: 20.0),
            const MediumText.bold(
              'Uau! Você não fez dívidas com ninguém ainda. Continue assim!',
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }
}
