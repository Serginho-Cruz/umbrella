// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'credit_card.dart';
import 'invoice_item.dart';

class Invoice {
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
}
