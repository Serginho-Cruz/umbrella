import 'package:equatable/equatable.dart';
import 'account.dart';

class CreditCard extends Equatable {
  final int id;
  final String name;
  final double annuity;
  final String color;
  final int cardInvoiceClosingDay;
  final int cardInvoiceDueDay;
  final Account accountToDiscountInvoice;

  const CreditCard({
    required this.id,
    required this.name,
    required this.annuity,
    required this.color,
    required this.cardInvoiceClosingDay,
    required this.cardInvoiceDueDay,
    required this.accountToDiscountInvoice,
  });

  factory CreditCard.withoutId({
    required String name,
    required double annuity,
    required String color,
    required int cardInvoiceClosingDay,
    required int cardInvoiceDueDay,
    required Account accountToDiscountInvoice,
  }) {
    return CreditCard(
      id: 0,
      name: name,
      annuity: annuity,
      color: color,
      cardInvoiceClosingDay: cardInvoiceClosingDay,
      cardInvoiceDueDay: cardInvoiceDueDay,
      accountToDiscountInvoice: accountToDiscountInvoice,
    );
  }

  CreditCard copyWith({
    int? id,
    String? name,
    double? annuity,
    String? color,
    int? cardInvoiceClosingDay,
    int? cardInvoiceDueDay,
    Account? accountToDiscountInvoice,
  }) {
    return CreditCard(
      annuity: annuity ?? this.annuity,
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      cardInvoiceClosingDay:
          cardInvoiceClosingDay ?? this.cardInvoiceClosingDay,
      cardInvoiceDueDay: cardInvoiceDueDay ?? this.cardInvoiceDueDay,
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
        cardInvoiceClosingDay,
        cardInvoiceDueDay,
        accountToDiscountInvoice,
      ];
}
