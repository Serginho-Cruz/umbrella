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
  final Account accountToDiscount;
  final double interest;

  const Invoice({
    required super.id,
    required super.totalValue,
    required super.paidValue,
    required super.remainingValue,
    required super.dueDate,
    super.paymentDate,
    required this.isClosed,
    required this.closingDate,
    required this.card,
    required this.itens,
    required this.accountToDiscount,
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
    Account? accountToDiscount,
    double? interest,
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
      accountToDiscount: accountToDiscount ?? this.accountToDiscount,
      interest: interest ?? this.interest,
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
        accountToDiscount,
        interest,
      ];
}
