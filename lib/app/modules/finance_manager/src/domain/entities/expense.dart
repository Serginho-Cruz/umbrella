import 'package:equatable/equatable.dart';

import '../../utils/extensions.dart';
import 'expense_type.dart';
import 'frequency.dart';

class Expense extends Equatable {
  final int id;
  final double value;
  final String name;
  final DateTime dueDate;
  final String? personName;
  final ExpenseType type;
  final Frequency frequency;

  const Expense({
    required this.id,
    required this.value,
    required this.name,
    required this.dueDate,
    this.personName,
    required this.type,
    required this.frequency,
  });

  factory Expense.withoutId({
    required double value,
    required String name,
    required DateTime dueDate,
    String? personName,
    required ExpenseType type,
    required Frequency frequency,
  }) =>
      Expense(
        id: 0,
        value: value,
        name: name,
        dueDate: dueDate,
        personName: personName,
        type: type,
        frequency: frequency,
      );

  @override
  List<Object?> get props => [
        id,
        name,
        value,
        dueDate.date,
        personName,
        type,
        frequency,
      ];
}
