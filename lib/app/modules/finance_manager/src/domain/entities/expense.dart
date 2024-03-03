import 'package:equatable/equatable.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/date.dart';

import 'expense_type.dart';
import 'frequency.dart';
import 'paiyable.dart';

class Expense extends Paiyable with EquatableMixin {
  final String name;
  final String? personName;
  final ExpenseType type;
  final Frequency frequency;

  const Expense({
    required super.id,
    required this.name,
    required super.totalValue,
    required super.paidValue,
    required super.remainingValue,
    required super.dueDate,
    required super.paymentDate,
    this.personName,
    required this.type,
    required this.frequency,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        totalValue,
        paidValue,
        remainingValue,
        paymentDate,
        dueDate,
        personName,
        type,
        frequency,
      ];

  Expense copyWith({
    int? id,
    String? name,
    double? totalValue,
    double? paidValue,
    double? remainingValue,
    Date? dueDate,
    Date? paymentDate,
    String? personName,
    ExpenseType? type,
    Frequency? frequency,
  }) {
    return Expense(
      id: id ?? this.id,
      name: name ?? this.name,
      totalValue: totalValue ?? this.totalValue,
      paidValue: paidValue ?? this.paidValue,
      remainingValue: remainingValue ?? this.remainingValue,
      dueDate: dueDate ?? this.dueDate,
      paymentDate: paymentDate ?? this.paymentDate,
      personName: personName ?? this.personName,
      type: type ?? this.type,
      frequency: frequency ?? this.frequency,
    );
  }
}
