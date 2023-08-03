// ignore_for_file: public_member_api_docs, sort_constructors_first
import '../../utils/extensions.dart';
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
    required DateTime dueDate,
    required double paidValue,
    required double remainingValue,
    required double totalValue,
    DateTime? paymentDate,
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
        paymentDate?.date,
        totalValue,
      ];

  ExpenseParcel copyWith({
    Expense? expense,
    DateTime? dueDate,
    int? id,
    double? paidValue,
    double? remainingValue,
    DateTime? paymentDate,
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
