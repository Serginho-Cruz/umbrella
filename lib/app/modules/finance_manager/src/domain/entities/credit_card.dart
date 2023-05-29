import 'package:equatable/equatable.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/utils/datetime_extension.dart';

class CreditCard with EquatableMixin {
  int id;
  String name;
  double annuity;
  String color;
  DateTime cardInvoiceClosingDate;
  DateTime cardInvoiceExpirationDate;

  CreditCard({
    required this.id,
    required this.name,
    required this.annuity,
    required this.color,
    required this.cardInvoiceClosingDate,
    required this.cardInvoiceExpirationDate,
  });

  factory CreditCard.withoutId({
    required String name,
    required double annuity,
    required String color,
    required DateTime cardInvoiceClosingDate,
    required DateTime cardInvoiceExpirationDate,
  }) {
    return CreditCard(
      id: 0,
      name: name,
      annuity: annuity,
      color: color,
      cardInvoiceClosingDate: cardInvoiceClosingDate,
      cardInvoiceExpirationDate: cardInvoiceExpirationDate,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        annuity,
        color,
        cardInvoiceClosingDate.date,
        cardInvoiceExpirationDate.date,
      ];
}
