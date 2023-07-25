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
}
