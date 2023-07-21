import 'package:equatable/equatable.dart';

import '../../utils/extensions.dart';

class CreditCard extends Equatable {
  final int id;
  final String name;
  final double annuity;
  final String color;
  final DateTime cardInvoiceClosingDate;
  final DateTime cardInvoiceDueDate;

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
    required DateTime cardInvoiceClosingDate,
    required DateTime cardInvoiceDueDate,
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

  @override
  List<Object?> get props => [
        id,
        name,
        annuity,
        color,
        cardInvoiceClosingDate.date,
        cardInvoiceDueDate.date,
      ];
}
