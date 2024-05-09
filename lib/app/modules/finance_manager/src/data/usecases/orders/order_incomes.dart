import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/income.dart';

import '../../../domain/usecases/orders/order_incomes.dart';

class OrderIncomesImpl implements OrderIncomes {
  @override
  List<Income> byName({
    required List<Income> incomes,
    required bool isAlphabetic,
  }) =>
      _sortList(
        sortFunction: (a, b) => a.name.compareTo(b.name),
        incomes: incomes,
        isCrescent: isAlphabetic,
      );

  @override
  List<Income> byValue({
    required List<Income> incomes,
    required bool isCrescent,
  }) =>
      _sortList(
        sortFunction: (a, b) => a.totalValue.compareTo(b.totalValue),
        incomes: incomes,
        isCrescent: isCrescent,
      );

  @override
  List<Income> byDueDate({
    required List<Income> incomes,
    required bool isCrescent,
  }) =>
      _sortList(
        sortFunction: (a, b) => a.dueDate.compareTo(b.dueDate),
        incomes: incomes,
        isCrescent: isCrescent,
      );

  @override
  List<Income> revertOrder(List<Income> incomes) => incomes.reversed.toList();

  List<Income> _sortList({
    required int Function(Income, Income) sortFunction,
    required List<Income> incomes,
    required bool isCrescent,
  }) {
    //Multiplier Number in compare will order the list in crescent or decrescent
    //without using .reverse in the final of processing, saving cellphone resources

    int multiplierNumber = isCrescent ? 1 : -1;
    return List.from(incomes)
      ..sort((a, b) => sortFunction(a, b) * multiplierNumber);
  }
}
