import 'package:equatable/equatable.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/utils/datetime_extension.dart';

import 'credit_card.dart';
import 'invoice_item.dart';

class Invoice with EquatableMixin {
  int id;
  double value;
  bool isClosed;
  DateTime expirationDate;
  DateTime closingDate;
  CreditCard card;
  List<InvoiceItem> itens;

  Invoice({
    required this.id,
    required this.value,
    required this.isClosed,
    required this.expirationDate,
    required this.closingDate,
    required this.card,
    required this.itens,
  });

  @override
  List<Object?> get props => [
        id,
        value,
        isClosed,
        expirationDate.date,
        closingDate.date,
        card,
        itens,
      ];
}
