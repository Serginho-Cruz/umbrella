import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/usecases/filters/filter_finance_model.dart';
import '../../../domain/entities/category.dart';
import '../../../domain/models/expense_model.dart';
import '../../../domain/usecases/filters/filter_expenses.dart';

class FilterExpensesImpl extends FilterFinanceModel<ExpenseModel>
    implements FilterExpenses {
  @override
  List<ExpenseModel> byName({
    required List<ExpenseModel> models,
    required String searchName,
  }) =>
      models
          .where((e) => e.name.toLowerCase().contains(searchName.toLowerCase()))
          .toList();

  @override
  List<ExpenseModel> byCategory({
    required List<ExpenseModel> models,
    required List<Category> categories,
  }) =>
      models.where((e) => categories.contains(e.category)).toList();
}
