import 'package:equatable/equatable.dart';
import 'account.dart';

class CreditCard extends Equatable {
  final String id;
  final String name;
  final String color;
  final int cardInvoiceClosingDay;
  final int cardInvoiceDueDay;
  final Account accountToDiscountInvoice;

  const CreditCard({
    required this.id,
    required this.name,
    required this.color,
    required this.cardInvoiceClosingDay,
    required this.cardInvoiceDueDay,
    required this.accountToDiscountInvoice,
  });

  factory CreditCard.withoutId({
    required String name,
    required String color,
    required int cardInvoiceClosingDay,
    required int cardInvoiceDueDay,
    required Account accountToDiscountInvoice,
  }) {
    return CreditCard(
      id: '',
      name: name,
      color: color,
      cardInvoiceClosingDay: cardInvoiceClosingDay,
      cardInvoiceDueDay: cardInvoiceDueDay,
      accountToDiscountInvoice: accountToDiscountInvoice,
    );
  }

  CreditCard copyWith({
    String? id,
    String? name,
    String? color,
    int? cardInvoiceClosingDay,
    int? cardInvoiceDueDay,
    Account? accountToDiscountInvoice,
  }) {
    return CreditCard(
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
        color,
        cardInvoiceClosingDay,
        cardInvoiceDueDay,
        accountToDiscountInvoice,
      ];
}
