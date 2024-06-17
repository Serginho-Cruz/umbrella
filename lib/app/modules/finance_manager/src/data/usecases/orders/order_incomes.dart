import '../../../domain/models/income_model.dart';
import '../../../domain/usecases/orders/order_incomes.dart';

class OrderIncomesImpl implements OrderIncomes {
  @override
  List<IncomeModel> byName(
    List<IncomeModel> incomes, {
    bool isCrescent = true,
  }) =>
      _sortList(
        sortFunction: (a, b) => a.name.compareTo(b.name),
        incomes: incomes,
        isCrescent: isCrescent,
      );

  @override
  List<IncomeModel> byValue(
    List<IncomeModel> incomes, {
    bool isCrescent = true,
  }) =>
      _sortList(
        sortFunction: (a, b) => a.totalValue.compareTo(b.totalValue),
        incomes: incomes,
        isCrescent: isCrescent,
      );

  @override
  List<IncomeModel> byDueDate(
    List<IncomeModel> incomes, {
    bool isCrescent = true,
  }) =>
      _sortList(
        sortFunction: (a, b) => a.overdueDate.compareTo(b.overdueDate),
        incomes: incomes,
        isCrescent: isCrescent,
      );

  List<IncomeModel> _sortList({
    required int Function(IncomeModel, IncomeModel) sortFunction,
    required List<IncomeModel> incomes,
    required bool isCrescent,
  }) {
    //Multiplier Number in compare will order the list in crescent or decrescent
    //without using .reverse in the final of processing, saving cellphone resources

    int multiplierNumber = isCrescent ? 1 : -1;
    return List.from(incomes)
      ..sort((a, b) => sortFunction(a, b) * multiplierNumber);
  }
}
