import 'package:equatable/equatable.dart';
import 'account.dart';
import 'date.dart';

class CreditCard extends Equatable {
  final int id;
  final String name;
  final double annuity;
  final String color;
  final Date cardInvoiceClosingDate;
  final Date cardInvoiceDueDate;
  final Account accountToDiscountInvoice;

  const CreditCard({
    required this.id,
    required this.name,
    required this.annuity,
    required this.color,
    required this.cardInvoiceClosingDate,
    required this.cardInvoiceDueDate,
    required this.accountToDiscountInvoice,
  });

  factory CreditCard.withoutId({
    required String name,
    required double annuity,
    required String color,
    required Date cardInvoiceClosingDate,
    required Date cardInvoiceDueDate,
    required Account accountToDiscountInvoice,
  }) {
    return CreditCard(
      id: 0,
      name: name,
      annuity: annuity,
      color: color,
      cardInvoiceClosingDate: cardInvoiceClosingDate,
      cardInvoiceDueDate: cardInvoiceDueDate,
      accountToDiscountInvoice: accountToDiscountInvoice,
    );
  }

  CreditCard copyWith({
    int? id,
    String? name,
    double? annuity,
    String? color,
    Date? cardInvoiceClosingDate,
    Date? cardInvoiceDueDate,
    Account? accountToDiscountInvoice,
  }) {
    return CreditCard(
      annuity: annuity ?? this.annuity,
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      cardInvoiceClosingDate:
          cardInvoiceClosingDate ?? this.cardInvoiceClosingDate,
      cardInvoiceDueDate: cardInvoiceDueDate ?? this.cardInvoiceDueDate,
      accountToDiscountInvoice:
          accountToDiscountInvoice ?? this.accountToDiscountInvoice,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        annuity,
        color,
        cardInvoiceClosingDate,
        cardInvoiceDueDate,
        accountToDiscountInvoice,
      ];
}
