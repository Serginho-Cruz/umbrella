// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/credit_card.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/date.dart';

class CreditCardModel {
  final String name;
  final String color;
  final Date overdueDate;
  final double castValue;

  const CreditCardModel({
    required this.name,
    required this.color,
    required this.overdueDate,
    required this.castValue,
  });

  static CreditCardModel fromEntity(
    CreditCard entity, {
    required double castValue,
  }) {
    return CreditCardModel(
      name: entity.name,
      color: entity.color,
      overdueDate: entity.cardInvoiceDueDate,
      castValue: castValue,
    );
  }
}
