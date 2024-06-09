import 'package:intl/intl.dart';

sealed class CurrencyFormat {
  static final _formatter = NumberFormat.currency(
    decimalDigits: 2,
    locale: 'pt_br',
    symbol: 'R\$',
  );

  static String format(num number) => _formatter.format(number);

  static get formatter => _formatter;
}
