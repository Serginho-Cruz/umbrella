import 'package:equatable/equatable.dart';
import 'date.dart';

class CreditCard extends Equatable {
  final int id;
  final String name;
  final double annuity;
  final String color;
  final Date cardInvoiceClosingDate;
  final Date cardInvoiceDueDate;

  const CreditCard({
    required this.id,
    required this.name,
    required this.annuity,
    required this.color,
    required this.cardInvoiceClosingDate,
    required this.cardInvoiceDueDate,
  });

  factory CreditCard.withoutId({
    required String name,
    required double annuity,
    required String color,
    required Date cardInvoiceClosingDate,
    required Date cardInvoiceDueDate,
  }) {
    return CreditCard(
      id: 0,
      name: name,
      annuity: annuity,
      color: color,
      cardInvoiceClosingDate: cardInvoiceClosingDate,
      cardInvoiceDueDate: cardInvoiceDueDate,
    );
  }

  CreditCard copyWith({
    int? id,
    String? name,
    double? annuity,
    String? color,
    Date? cardInvoiceClosingDate,
    Date? cardInvoiceDueDate,
  }) {
    return CreditCard(
      annuity: annuity ?? this.annuity,
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      cardInvoiceClosingDate:
          cardInvoiceClosingDate ?? this.cardInvoiceClosingDate,
      cardInvoiceDueDate: cardInvoiceDueDate ?? this.cardInvoiceDueDate,
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
      ];
}
