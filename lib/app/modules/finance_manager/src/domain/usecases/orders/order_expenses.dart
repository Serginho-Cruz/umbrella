import '../../models/expense_model.dart';

enum PaiyableSortOption { byName, byValue, byDueDate }

abstract interface class OrderExpenses {
  List<ExpenseModel> byValue(List<ExpenseModel> expenses, {bool isCrescent});
  List<ExpenseModel> byName(List<ExpenseModel> expenses, {bool isCrescent});
  List<ExpenseModel> byDueDate(List<ExpenseModel> expenses, {bool isCrescent});
}
