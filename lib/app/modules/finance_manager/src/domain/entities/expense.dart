import 'package:equatable/equatable.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/date.dart';

import 'account.dart';
import 'category.dart';
import 'frequency.dart';
import 'paiyable.dart';

class Expense extends Paiyable with EquatableMixin {
  final String name;
  final String? personName;
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
    super.paymentDate,
    this.personName,
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
        paymentDate,
        dueDate,
        personName,
        category,
        account,
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
      paymentDate: paymentDate ?? this.paymentDate,
      personName: personName ?? this.personName,
      category: category ?? this.category,
      account: account ?? this.account,
      frequency: frequency ?? this.frequency,
    );
  }
}
