import '../entities/expense.dart';
import 'finance_model.dart';

class ExpenseModel extends FinanceModel {
  ExpenseModel.fromExpense(
    Expense expense, {
    required super.status,
  }) : super(
          id: expense.id,
          name: expense.name,
          totalValue: expense.totalValue,
          paidValue: expense.paidValue,
          remainingValue: expense.remainingValue,
          category: expense.category,
          frequency: expense.frequency,
          personName: expense.personName,
          overdueDate: expense.dueDate,
          paymentDate: expense.paymentDate,
        );

  Expense toEntity() {
    return Expense(
      id: id,
      name: name,
      totalValue: totalValue,
      paidValue: paidValue,
      remainingValue: remainingValue,
      dueDate: overdueDate,
      category: category,
      frequency: frequency,
      paymentDate: paymentDate,
      personName: personName,
    );
  }
}
