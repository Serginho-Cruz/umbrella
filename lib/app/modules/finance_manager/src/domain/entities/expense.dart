import 'package:equatable/equatable.dart';

import '../../utils/extensions.dart';
import 'expense_type.dart';
import 'frequency.dart';

class Expense with EquatableMixin {
  int id;
  double value;
  String name;
  DateTime expirationDate;
  String? personName;
  ExpenseType type;
  Frequency frequency;

  Expense({
    required this.id,
    required this.value,
    required this.name,
    required this.expirationDate,
    this.personName,
    required this.type,
    required this.frequency,
  });

  factory Expense.withoutId({
    required double value,
    required String name,
    required DateTime expirationDate,
    String? personName,
    required ExpenseType type,
    required Frequency frequency,
  }) =>
      Expense(
        id: 0,
        value: value,
        name: name,
        expirationDate: expirationDate,
        personName: personName,
        type: type,
        frequency: frequency,
      );

  @override
  List<Object?> get props => [
        id,
        name,
        value,
        expirationDate.date,
        personName,
        type,
        frequency,
      ];
}
