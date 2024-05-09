import '../../entities/income.dart';
import '../../entities/income_type.dart';

abstract interface class FilterIncomes {
  List<Income> byName({
    required List<Income> incomes,
    required String searchName,
  });
  List<Income> byPaid(List<Income> incomes);
  List<Income> byUnpaid(List<Income> incomes);
  List<Income> byOverdue(List<Income> incomes);
  List<Income> byType({
    required List<Income> incomes,
    required IncomeType type,
  });
}
