import 'package:equatable/equatable.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/date.dart';
import 'expense_type.dart';
import 'frequency.dart';

class Expense extends Equatable {
  final int id;
  final double value;
  final String name;
  final Date dueDate;
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
    required Date dueDate,
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

  Expense copyWith({
    int? id,
    double? value,
    String? name,
    Date? dueDate,
    String? personName,
    ExpenseType? type,
    Frequency? frequency,
  }) {
    return Expense(
      id: id ?? this.id,
      value: value ?? this.value,
      name: name ?? this.name,
      dueDate: dueDate ?? this.dueDate,
      personName: personName ?? this.personName,
      type: type ?? this.type,
      frequency: frequency ?? this.frequency,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        value,
        dueDate,
        personName,
        type,
        frequency,
      ];
}
