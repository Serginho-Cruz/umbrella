import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/models/expense_model.dart';

import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/models/income_model.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/utils/round.dart';

import '../../domain/models/finance_model.dart';
import '../../domain/usecases/gets/get_persons.dart';
import '../../domain/usecases/obtain_persons_debts.dart';

class ObtainPersonsDebtsImpl implements ObtainPersonsDebts {
  final GetPersons _getPersons;

  ObtainPersonsDebtsImpl(this._getPersons);

  @override
  Future<Map<String, double>> call({
    required List<IncomeModel> incomeModels,
    required List<ExpenseModel> expenseModels,
  }) async {
    var names = await _getPersons();

    Map<String, double> map = {};

    for (var name in names) {
      map.putIfAbsent(name, () => 0.00);
    }

    var filteredIncomes = _filterWhereHasPerson(incomeModels);
    var filteredExpenses = _filterWhereHasPerson(expenseModels);

    for (var income in filteredIncomes) {
      map.update(
        income.personName!,
        (value) => (value + income.remainingValue).roundToDecimal(),
        ifAbsent: () => income.remainingValue.roundToDecimal(),
      );
    }

    for (var expense in filteredExpenses) {
      map.update(
        expense.personName!,
        (value) => (value - expense.remainingValue).roundToDecimal(),
        ifAbsent: () => -expense.remainingValue.roundToDecimal(),
      );
    }

    return map;
  }

  List<T> _filterWhereHasPerson<T extends FinanceModel>(List<T> models) {
    return models
        .where((element) =>
            element.personName != null &&
            element.personName?.isNotEmpty == true)
        .toList();
  }
}
