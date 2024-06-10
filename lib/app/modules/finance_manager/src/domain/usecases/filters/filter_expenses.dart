import '../../entities/category.dart';
import '../../entities/expense.dart';

abstract interface class FilterExpenses {
  List<Expense> byName({
    required List<Expense> expenses,
    required String searchName,
  });
  List<Expense> byPaid(List<Expense> expenses);
  List<Expense> byUnpaid(List<Expense> expenses);
  List<Expense> byOverdue(List<Expense> expenses);
  List<Expense> byCategory({
    required List<Expense> expenses,
    required Category category,
  });
}
