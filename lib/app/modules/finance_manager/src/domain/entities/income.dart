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
  final Category category;

  const Income({
    required super.id,
    required this.name,
    required super.totalValue,
    required super.paidValue,
    required super.remainingValue,
    required super.dueDate,
    required super.account,
    super.paymentDate,
    required this.frequency,
    this.personName,
    required this.category,
  });

  Income copyWith({
    int? id,
    String? name,
    double? totalValue,
    double? paidValue,
    double? remainingValue,
    Date? dueDate,
    Date? paymentDate,
    Frequency? frequency,
    String? personName,
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
      paymentDate: paymentDate ?? this.paymentDate,
      frequency: frequency ?? this.frequency,
      personName: personName ?? this.personName,
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
        paymentDate,
        frequency,
        category,
        account,
        personName,
      ];
}
