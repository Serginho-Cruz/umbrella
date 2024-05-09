import '../../../domain/entities/expense.dart';
import '../../../domain/usecases/orders/order_expenses.dart';

class OrderExpensesImpl implements OrderExpenses {
  @override
  List<Expense> byName({
    required List<Expense> expenses,
    required bool isAlphabetic,
  }) =>
      _sortList(
        sortFunction: (a, b) => a.name.compareTo(b.name),
        expenses: expenses,
        isCrescent: isAlphabetic,
      );

  @override
  List<Expense> byValue({
    required List<Expense> expenses,
    required bool isCrescent,
  }) =>
      _sortList(
        sortFunction: (a, b) => a.totalValue.compareTo(b.totalValue),
        isCrescent: isCrescent,
        expenses: expenses,
      );

  @override
  List<Expense> byDueDate({
    required List<Expense> expenses,
    required bool isCrescent,
  }) =>
      _sortList(
        sortFunction: (a, b) => a.dueDate.compareTo(b.dueDate),
        isCrescent: isCrescent,
        expenses: expenses,
      );

  @override
  List<Expense> revertOrder(List<Expense> expenses) =>
      expenses.reversed.toList();

  List<Expense> _sortList({
    required int Function(Expense, Expense) sortFunction,
    required List<Expense> expenses,
    required bool isCrescent,
  }) {
    //Multiplier Number in compare will order the list in crescent or decrescent
    //without using .reverse in the final of processing, saving cellphone resources
    int multiplierNumber = isCrescent ? 1 : -1;
    return List.from(expenses)
      ..sort((a, b) => sortFunction(a, b) * multiplierNumber);
  }
}
