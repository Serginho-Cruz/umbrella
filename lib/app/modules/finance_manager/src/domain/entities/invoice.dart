import 'account.dart';
import 'date.dart';
import 'credit_card.dart';
import 'invoice_item.dart';
import 'paiyable.dart';

class Invoice extends Paiyable {
  final bool isClosed;
  final Date closingDate;
  final CreditCard card;
  final List<InvoiceItem> itens;
  final double adjust;
  final double interest;

  const Invoice({
    required super.id,
    required super.totalValue,
    required super.paidValue,
    required super.remainingValue,
    required super.dueDate,
    super.paymentDate,
    required super.account,
    required this.isClosed,
    required this.closingDate,
    required this.card,
    required this.itens,
    this.adjust = 0.00,
    this.interest = 0.00,
  });
  Invoice copyWith({
    bool? isClosed,
    Date? closingDate,
    CreditCard? card,
    List<InvoiceItem>? itens,
    int? id,
    double? paidValue,
    double? remainingValue,
    Date? dueDate,
    Date? paymentDate,
    double? totalValue,
    Account? account,
    double? interest,
    double? adjust,
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
      account: account ?? this.account,
      interest: interest ?? this.interest,
      adjust: adjust ?? this.adjust,
    );
  }

  @override
  List<Object?> get props => [
        id,
        isClosed,
        dueDate,
        closingDate,
        card,
        itens,
        paidValue,
        remainingValue,
        paymentDate,
        totalValue,
        account,
        interest,
        adjust,
      ];
}
