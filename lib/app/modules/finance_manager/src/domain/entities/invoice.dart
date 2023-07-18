import '../../utils/extensions.dart';
import 'credit_card.dart';
import 'invoice_item.dart';
import 'paiyable.dart';

class Invoice extends Paiyable {
  bool isClosed;
  DateTime closingDate;
  CreditCard card;
  List<InvoiceItem> itens;

  Invoice({
    required this.isClosed,
    required this.closingDate,
    required this.card,
    required this.itens,
    required super.id,
    required super.paidValue,
    required super.remainingValue,
    required super.dueDate,
    super.paymentDate,
    required super.totalValue,
  });

  @override
  List<Object?> get props => [
        id,
        isClosed,
        dueDate.date,
        closingDate.date,
        card,
        itens,
        paidValue,
        remainingValue,
        paymentDate,
        totalValue,
      ];
}
