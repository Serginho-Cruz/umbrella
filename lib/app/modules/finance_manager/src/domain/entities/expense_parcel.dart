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
    required super.paymentDate,
    required super.totalValue,
  });

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
