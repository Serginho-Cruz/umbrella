import 'package:flutter_triple/flutter_triple.dart';
import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/usecases/manage_income.dart';

import '../../domain/entities/account.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/date.dart';
import '../../domain/entities/income.dart';
import '../../domain/models/income_model.dart';
import '../../domain/models/status.dart';
import '../../domain/usecases/filters/filter_incomes.dart';
import '../../domain/usecases/sorts/sort_expenses.dart';
import '../../domain/usecases/sorts/sort_incomes.dart';
import '../../errors/errors.dart';

class IncomeStore extends Store<List<IncomeModel>> {
  final ManageIncome _manageIncome;
  final FilterIncomes _filterIncomes;
  final SortIncomes _sortIncomes;

  final List<IncomeModel> all = [];

  IncomeStore({
    required ManageIncome manageIncome,
    required FilterIncomes filterIncomes,
    required SortIncomes sortIncomes,
  })  : _manageIncome = manageIncome,
        _filterIncomes = filterIncomes,
        _sortIncomes = sortIncomes,
        super([]);

  AsyncResult<int, Fail> register(Income expense) async {
    var result = await _manageIncome.register(expense);

    return result;
  }

  AsyncResult<void, Fail> updateValue(
    Income income,
    double newValue,
  ) =>
      _manageIncome.updateValue(income, newValue);

  AsyncResult<void, Fail> switchAccount(
    Income income,
    Account newAccount,
  ) =>
      _manageIncome.switchAccount(income, newAccount);

  AsyncResult<void, Fail> updateIncome({
    required Income oldIncome,
    required Income newIncome,
  }) =>
      _manageIncome.update(
        oldIncome: oldIncome,
        newIncome: newIncome,
      );

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
        all.clear();
        setError(result.exceptionOrNull()!);
        setLoading(false);

        return;
      }

      var incomes = result.getOrDefault([]);

      models.addAll(incomes.map((i) => _toModel(i)));
    }

    models = sort(models, PaiyableSortOption.byDueDate, isCrescent: true);

    all
      ..clear()
      ..addAll(models);

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

      models = sort(models, PaiyableSortOption.byDueDate, isCrescent: true);

      all
        ..clear()
        ..addAll(models);

      update(models);
    }, (fail) {
      all.clear();
      setError(fail);
    });

    setLoading(false);
  }

  void filterByName(String name) {
    var filtered = _filterIncomes.byName(models: all, searchName: name);

    update(filtered);
  }

  List<IncomeModel> filterByCategory(
    List<IncomeModel> models,
    List<Category> categories,
  ) {
    return _filterIncomes.byCategory(models: models, categories: categories);
  }

  List<IncomeModel> filterByStatus(
    List<IncomeModel> models,
    List<Status> status,
  ) {
    return _filterIncomes.byStatus(models: models, status: status);
  }

  List<IncomeModel> filterByRangeValue(
    List<IncomeModel> models,
    double min,
    double max,
  ) {
    return _filterIncomes.byRangeValue(models: models, min: min, max: max);
  }

  List<IncomeModel> sort(
    List<IncomeModel> models,
    PaiyableSortOption option, {
    bool isCrescent = true,
  }) {
    return switch (option) {
      PaiyableSortOption.byValue => _sortIncomes.byValue(
          models,
          isCrescent: isCrescent,
        ),
      PaiyableSortOption.byName => _sortIncomes.byName(
          models,
          isCrescent: isCrescent,
        ),
      PaiyableSortOption.byDueDate => _sortIncomes.byDueDate(
          models,
          isCrescent: isCrescent,
        ),
    };
  }

  void updateState(List<IncomeModel> newState) {
    update(newState);
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
