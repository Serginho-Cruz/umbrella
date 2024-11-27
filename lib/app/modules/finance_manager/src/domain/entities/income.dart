import 'package:equatable/equatable.dart';
import 'account.dart';
import 'category.dart';
import 'paiyable.dart';
import 'date.dart';
import 'frequency.dart';

class Income extends Paiyable with EquatableMixin {
  final String name;
  final Frequency frequency;
  final String? personName;
  final String? frequentIncomeId;
  final Category category;

  const Income({
    required super.id,
    required this.name,
    required super.totalValue,
    required super.paidValue,
    required super.remainingValue,
    required super.dueDate,
    required super.account,
    required this.frequency,
    this.personName,
    this.frequentIncomeId,
    required this.category,
  });

  Income copyWith({
    String? id,
    String? name,
    double? totalValue,
    double? paidValue,
    double? remainingValue,
    Date? dueDate,
    Frequency? frequency,
    String? personName,
    String? frequentIncomeId,
    Category? category,
    Account? account,
  }) {
    return Income(
      id: id ?? this.id,
      name: name ?? this.name,
      totalValue: totalValue ?? this.totalValue,
      paidValue: paidValue ?? this.paidValue,
      remainingValue: remainingValue ?? this.remainingValue,
      dueDate: dueDate ?? this.dueDate,
      frequency: frequency ?? this.frequency,
      personName: personName ?? this.personName,
      frequentIncomeId: frequentIncomeId ?? this.frequentIncomeId,
      category: category ?? this.category,
      account: account ?? this.account,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        totalValue,
        paidValue,
        remainingValue,
        dueDate,
        frequency,
        category,
        account,
        personName,
        frequentIncomeId,
      ];
}
