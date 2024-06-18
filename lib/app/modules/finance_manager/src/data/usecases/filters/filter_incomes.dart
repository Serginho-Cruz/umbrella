import '../../../domain/entities/category.dart';
import '../../../domain/models/income_model.dart';
import '../../../domain/usecases/filters/filter_incomes.dart';
import 'filter_finance_model.dart';

class FilterIncomesImpl extends FilterFinanceModel<IncomeModel>
    implements FilterIncomes {
  @override
  List<IncomeModel> byCategory({
    required List<IncomeModel> models,
    required List<Category> categories,
  }) =>
      categories.isEmpty
          ? models
          : models.where((i) => categories.contains(i.category)).toList();

  @override
  List<IncomeModel> byName({
    required List<IncomeModel> models,
    required String searchName,
  }) =>
      models
          .where((i) => i.name.toLowerCase().contains(searchName.toLowerCase()))
          .toList();
}
