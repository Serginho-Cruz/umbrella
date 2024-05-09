import '../../entities/expense.dart';

abstract interface class OrderExpenses {
  List<Expense> byValue({
    required List<Expense> expenses,
    required bool isCrescent,
  });
  List<Expense> byName({
    required List<Expense> expenses,
    required bool isAlphabetic,
  });
  List<Expense> byDueDate({
    required List<Expense> expenses,
    required bool isCrescent,
  });
  List<Expense> revertOrder(List<Expense> expenses);
}
