import '../../entities/income.dart';

abstract class IOrderIncomes {
  List<Income> byValue({
    required List<Income> incomes,
    required bool isCrescent,
  });
  List<Income> byName({
    required List<Income> incomes,
    required bool isAlphabetic,
  });
  List<Income> byDueDate({
    required List<Income> incomes,
    required bool isCrescent,
  });
  List<Income> byID(List<Income> incomes);
  List<Income> revertOrder(List<Income> incomes);
}
