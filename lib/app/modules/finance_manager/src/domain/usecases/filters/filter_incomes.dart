import '../../entities/category.dart';
import '../../entities/income.dart';

abstract interface class FilterIncomes {
  List<Income> byName({
    required List<Income> incomes,
    required String searchName,
  });
  List<Income> byPaid(List<Income> incomes);
  List<Income> byUnpaid(List<Income> incomes);
  List<Income> byOverdue(List<Income> incomes);
  List<Income> byCategory({
    required List<Income> incomes,
    required Category category,
  });
}
