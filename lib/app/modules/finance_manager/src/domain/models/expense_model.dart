import '../entities/expense.dart';
import 'finance_model.dart';

class ExpenseModel extends FinanceModel {
  ExpenseModel({
    required super.id,
    required super.name,
    required super.totalValue,
    required super.paidValue,
    required super.remainingValue,
    required super.status,
    required super.overdueDate,
  });

  static ExpenseModel fromExpense(
    Expense expense, {
    required Status status,
  }) {
    return ExpenseModel(
      id: expense.id,
      name: expense.name,
      totalValue: expense.totalValue,
      paidValue: expense.paidValue,
      remainingValue: expense.remainingValue,
      status: status,
      overdueDate: expense.dueDate,
    );
  }
}
