import '../../entities/expense.dart';
import '../../entities/expense_type.dart';

abstract class IFilterExpenses {
  List<Expense> byName({
    required List<Expense> expenses,
    required String searchName,
  });
  List<Expense> byPaid(List<Expense> expenses);
  List<Expense> byUnpaid(List<Expense> expenses);
  List<Expense> byOverdue(List<Expense> expenses);
  List<Expense> byType({
    required List<Expense> expenses,
    required ExpenseType type,
  });
}
