import '../../entities/category.dart';
import '../../models/expense_model.dart';
import '../../models/finance_model.dart';

abstract interface class FilterExpenses {
  List<ExpenseModel> byName({
    required List<ExpenseModel> models,
    required String searchName,
  });
  List<ExpenseModel> byRangeValue({
    required List<ExpenseModel> models,
    required double min,
    required double max,
  });
  List<ExpenseModel> byStatus({
    required List<ExpenseModel> models,
    required List<Status> status,
  });
  List<ExpenseModel> byCategory({
    required List<ExpenseModel> models,
    required List<Category> categories,
  });
}
