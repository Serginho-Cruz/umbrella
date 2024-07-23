import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/credit_card.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/payment.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/usecases/manage_income.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/controllers/paiyable_store.dart';

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

class IncomeStore extends PaiyableStore<Income, IncomeModel> {
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

  @override
  AsyncResult<int, Fail> register(Income entity) async {
    var result = await _manageIncome.register(entity);

    return result;
  }

  @override
  AsyncResult<void, Fail> updateValue(
    IncomeModel paiyable,
    double newValue,
  ) =>
      _manageIncome.updateValue(paiyable.toEntity(), newValue);

  @override
  AsyncResult<void, Fail> switchAccount(
    IncomeModel paiyable,
    Account newAccount,
  ) =>
      _manageIncome.switchAccount(paiyable.toEntity(), newAccount);

  @override
  AsyncResult<void, Fail> edit({
    required Income oldPaiyable,
    required Income newPaiyable,
  }) =>
      _manageIncome.update(
        oldIncome: oldPaiyable,
        newIncome: newPaiyable,
      );

  @override
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

  @override
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

  @override
  AsyncResult<void, Fail> pay({
    required List<Payment<Income>> payments,
    CreditCard? card,
  }) async {
    return const Success(2);
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
