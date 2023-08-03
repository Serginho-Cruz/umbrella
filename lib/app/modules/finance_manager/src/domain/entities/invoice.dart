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
  Invoice copyWith({
    bool? isClosed,
    DateTime? closingDate,
    CreditCard? card,
    List<InvoiceItem>? itens,
    int? id,
    double? paidValue,
    double? remainingValue,
    DateTime? dueDate,
    DateTime? paymentDate,
    double? totalValue,
  }) {
    return Invoice(
      id: id ?? this.id,
      paidValue: paidValue ?? this.paidValue,
      remainingValue: remainingValue ?? this.remainingValue,
      dueDate: dueDate ?? this.dueDate,
      paymentDate: paymentDate ?? this.paymentDate,
      totalValue: totalValue ?? this.totalValue,
      isClosed: isClosed ?? this.isClosed,
      closingDate: closingDate ?? this.closingDate,
      card: card ?? this.card,
      itens: itens ?? this.itens,
    );
  }

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
