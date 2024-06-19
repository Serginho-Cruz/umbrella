import '../../entities/category.dart';
import '../../models/income_model.dart';
import '../../models/status.dart';

abstract interface class FilterIncomes {
  List<IncomeModel> byName({
    required List<IncomeModel> models,
    required String searchName,
  });
  List<IncomeModel> byRangeValue({
    required List<IncomeModel> models,
    required double min,
    required double max,
  });
  List<IncomeModel> byStatus({
    required List<IncomeModel> models,
    required List<Status> status,
  });
  List<IncomeModel> byCategory({
    required List<IncomeModel> models,
    required List<Category> categories,
  });
}
