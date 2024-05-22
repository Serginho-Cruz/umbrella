import 'dart:math';

import 'package:flutter/services.dart';

import 'currency_format.dart';
import 'manipulate_text.dart';

class CurrencyInputFormatter extends TextInputFormatter {
  static String unformat(String formattedCurrency) {
    String unformatted = formattedCurrency.replaceAll('.', '');
    unformatted = unformatted.replaceAll(',', '.');

    return unformatted.replaceAll('R\$', '');
  }

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return manipulateText(
      oldValue,
      newValue,
      textInputFormatter: FilteringTextInputFormatter.digitsOnly,
      // because FilteringTextInputFormatter.allow(RegExp(r'^-?[0-9]+')), does not work
      // https://github.com/flutter/flutter/issues/21874
      formatPattern: (String filteredString) {
        if (filteredString.isEmpty) return '';
        num number;
        number = int.tryParse(filteredString) ?? 0;

        number /= pow(10, 2);

        final result = CurrencyFormat.format(number);

        // Fix the -0+ and similar issues

        return result;
      },
    );
  }
}
