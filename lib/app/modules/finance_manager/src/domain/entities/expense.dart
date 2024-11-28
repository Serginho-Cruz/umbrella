import 'package:equatable/equatable.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/date.dart';

import 'account.dart';
import 'category.dart';
import 'frequency.dart';
import 'paiyable.dart';

class Expense extends Paiyable with EquatableMixin {
  final String name;
  final String? personName;
  final String? frequentExpenseId;
  final Frequency frequency;
  final Category category;

  const Expense({
    required super.id,
    required this.name,
    required super.totalValue,
    required super.paidValue,
    required super.remainingValue,
    required super.dueDate,
    required super.account,
    this.personName,
    this.frequentExpenseId,
    required this.category,
    required this.frequency,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        totalValue,
        paidValue,
        remainingValue,
        dueDate,
        personName,
        frequentExpenseId,
        category,
        account,
        frequency,
      ];

  Expense copyWith({
    String? id,
    String? name,
    double? totalValue,
    double? paidValue,
    double? remainingValue,
    Date? dueDate,
    String? personName,
    String? frequentExpenseId,
    Category? category,
    Frequency? frequency,
    Account? account,
  }) {
    return Expense(
      id: id ?? this.id,
      name: name ?? this.name,
      totalValue: totalValue ?? this.totalValue,
      paidValue: paidValue ?? this.paidValue,
      remainingValue: remainingValue ?? this.remainingValue,
      dueDate: dueDate ?? this.dueDate,
      personName: personName ?? this.personName,
      frequentExpenseId: frequentExpenseId ?? frequentExpenseId,
      category: category ?? this.category,
      account: account ?? this.account,
      frequency: frequency ?? this.frequency,
    );
  }
}
