import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/date.dart';

import 'expense.dart';
import 'paiyable.dart';

class ExpenseParcel extends Paiyable {
  final Expense expense;

  const ExpenseParcel({
    required this.expense,
    required super.dueDate,
    required super.id,
    required super.paidValue,
    required super.remainingValue,
    super.paymentDate,
    required super.totalValue,
  });

  factory ExpenseParcel.withoutId({
    required Expense expense,
    required Date dueDate,
    required double paidValue,
    required double remainingValue,
    required double totalValue,
    Date? paymentDate,
  }) =>
      ExpenseParcel(
        expense: expense,
        dueDate: dueDate,
        id: 0,
        paymentDate: paymentDate,
        paidValue: paidValue,
        remainingValue: remainingValue,
        totalValue: totalValue,
      );

  @override
  List<Object?> get props => [
        id,
        expense,
        dueDate,
        paidValue,
        remainingValue,
        paymentDate,
        totalValue,
      ];

  ExpenseParcel copyWith({
    Expense? expense,
    Date? dueDate,
    int? id,
    double? paidValue,
    double? remainingValue,
    Date? paymentDate,
    double? totalValue,
  }) {
    return ExpenseParcel(
      id: id ?? this.id,
      dueDate: dueDate ?? this.dueDate,
      paidValue: paidValue ?? this.paidValue,
      remainingValue: remainingValue ?? this.remainingValue,
      totalValue: totalValue ?? this.totalValue,
      paymentDate: paymentDate ?? this.paymentDate,
      expense: expense ?? this.expense,
    );
  }
}
