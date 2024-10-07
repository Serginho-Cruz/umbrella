import 'package:intl/intl.dart';

sealed class CurrencyFormat {
  static final _formatter = NumberFormat.currency(
    symbol: 'R\$',
    locale: 'pt_BR',
    customPattern: '¤ #,##0.00;¤ -#,##0.00',
  );

  static String format(num number) => _formatter.format(number);
}
