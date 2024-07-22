import '../../../domain/models/expense_model.dart';
import '../../../domain/usecases/sorts/sort_expenses.dart';

class SortExpensesImpl implements SortExpenses {
  @override
  List<ExpenseModel> byName(
    List<ExpenseModel> expenses, {
    bool isCrescent = true,
  }) =>
      _sortList(
        sortFunction: (a, b) => a.name.compareTo(b.name),
        expenses: expenses,
        isCrescent: isCrescent,
      );

  @override
  List<ExpenseModel> byValue(
    List<ExpenseModel> expenses, {
    bool isCrescent = true,
  }) =>
      _sortList(
        sortFunction: (a, b) => a.totalValue.compareTo(b.totalValue),
        isCrescent: isCrescent,
        expenses: expenses,
      );

  @override
  List<ExpenseModel> byDueDate(
    List<ExpenseModel> expenses, {
    bool isCrescent = true,
  }) =>
      _sortList(
        sortFunction: (a, b) => a.overdueDate.compareTo(b.overdueDate),
        isCrescent: isCrescent,
        expenses: expenses,
      );

  List<ExpenseModel> _sortList({
    required int Function(ExpenseModel, ExpenseModel) sortFunction,
    required List<ExpenseModel> expenses,
    required bool isCrescent,
  }) {
    //Multiplier Number in compare will order the list in crescent or decrescent
    //without using .reverse in the final of processing, saving cellphone resources
    int multiplierNumber = isCrescent ? 1 : -1;
    return List.from(expenses)
      ..sort((a, b) => sortFunction(a, b) * multiplierNumber);
  }
}
