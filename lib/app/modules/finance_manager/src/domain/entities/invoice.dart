import '../../utils/extensions.dart';
import 'credit_card.dart';
import 'invoice_item.dart';
import 'paiyable.dart';

class Invoice extends Paiyable {
  final bool isClosed;
  final DateTime closingDate;
  final CreditCard card;
  final List<InvoiceItem> itens;

  const Invoice({
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
