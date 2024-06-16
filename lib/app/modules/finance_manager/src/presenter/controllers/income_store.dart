import 'package:flutter_triple/flutter_triple.dart';
import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/usecases/manage_income.dart';

import '../../domain/entities/account.dart';
import '../../domain/entities/date.dart';
import '../../domain/entities/income.dart';
import '../../domain/models/finance_model.dart';
import '../../domain/models/income_model.dart';
import '../../domain/usecases/filters/filter_incomes.dart';
import '../../errors/errors.dart';

class IncomeStore extends Store<List<IncomeModel>> {
  final ManageIncome _manageIncome;
  final FilterIncomes _filterIncomes;

  List<IncomeModel> all = [];

  IncomeStore({
    required ManageIncome manageIncome,
    required FilterIncomes filterIncomes,
  })  : _manageIncome = manageIncome,
        _filterIncomes = filterIncomes,
        super([]);

  AsyncResult<int, Fail> register(Income expense, Account account) async {
    var result = await _manageIncome.register(expense, account);

    return result;
  }

  Future<void> getForAll({
    required List<Account> accounts,
    required int month,
    required int year,
  }) async {
    if (accounts.isEmpty) return;

    setLoading(true);

    List<IncomeModel> models = [];

    var list = List.generate(
        accounts.length,
        (i) => _manageIncome.getAllOf(
            month: month, year: year, account: accounts[i]));

    var results = await Future.wait(list);

    for (int i = 0; i < accounts.length; i++) {
      var result = results[i];

      if (result.isError()) {
        setError(result.exceptionOrNull()!);
        setLoading(false);

        return;
      }

      var incomes = result.getOrDefault([]);

      models.addAll(incomes.map((i) => _toModel(i)));
    }

    all = models;
    update(models);
    setLoading(false);
  }

  Future<void> getAllOf({
    required int month,
    required int year,
    required Account account,
  }) async {
    setLoading(true);

    var incomesResult = await _manageIncome.getAllOf(
      month: month,
      year: year,
      account: account,
    );

    incomesResult.fold((incomes) {
      var models = incomes.map((i) => _toModel(i)).toList();
      all = models;
      update(models);
    }, (fail) {
      setError(fail);
    });

    setLoading(false);
  }

  void filterByName(String name) {
    var incomes = state.map((e) => e.toEntity()).toList();

    var filtered = _filterIncomes.byName(incomes: incomes, searchName: name);

    update(filtered.map((i) => _toModel(i)).toList());
  }

  IncomeModel _toModel(Income i) {
    return IncomeModel.fromIncome(i, status: _determineStatus(i));
  }

  Status _determineStatus(Income i) {
    if (i.remainingValue == 0.00) return Status.okay;

    if (i.dueDate.isBefore(Date.today())) {
      return Status.overdue;
    }

    return Status.inTime;
  }
}
