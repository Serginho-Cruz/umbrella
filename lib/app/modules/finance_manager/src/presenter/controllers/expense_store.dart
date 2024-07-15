import 'package:flutter_triple/flutter_triple.dart';
import 'package:result_dart/result_dart.dart';

import '../../domain/entities/account.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/date.dart';
import '../../domain/entities/expense.dart';
import '../../domain/models/expense_model.dart';
import '../../domain/models/status.dart';
import '../../domain/usecases/filters/filter_expenses.dart';
import '../../domain/usecases/manage_expense.dart';
import '../../domain/usecases/orders/order_expenses.dart';
import '../../errors/errors.dart';

class ExpenseStore extends Store<List<ExpenseModel>> {
  ExpenseStore({
    required ManageExpense manageExpense,
    required FilterExpenses filterExpenses,
    required OrderExpenses orderExpenses,
  })  : _manageExpense = manageExpense,
        _filterExpenses = filterExpenses,
        _orderExpenses = orderExpenses,
        super([]);

  final ManageExpense _manageExpense;
  final FilterExpenses _filterExpenses;
  final OrderExpenses _orderExpenses;

  final List<ExpenseModel> all = [];

  AsyncResult<int, Fail> register(Expense expense) async {
    var result = await _manageExpense.register(expense);

    return result;
  }

  AsyncResult<void, Fail> updateValue(
    Expense expense,
    double newValue,
  ) =>
      _manageExpense.updateValue(expense, newValue);

  AsyncResult<void, Fail> switchAccount(
    Expense expense,
    Account newAccount,
  ) =>
      _manageExpense.switchAccount(expense, newAccount);

  AsyncResult<void, Fail> updateExpense({
    required Expense oldExpense,
    required Expense newExpense,
  }) =>
      _manageExpense.update(
        oldExpense: oldExpense,
        newExpense: newExpense,
      );

  Future<void> getForAll({
    required List<Account> accounts,
    required int month,
    required int year,
  }) async {
    if (accounts.isEmpty) return;

    setLoading(true);

    var list = List.generate(
      accounts.length,
      (i) => _manageExpense.getAllOf(
        month: month,
        year: year,
        account: accounts[i],
      ),
    );

    var results = await Future.wait(list);

    var models = <ExpenseModel>[];

    for (int i = 0; i < accounts.length; i++) {
      var result = results[i];

      if (result.isError()) {
        all.clear();
        setError(result.exceptionOrNull()!);
        setLoading(false);

        return;
      }

      var expenses = result.getOrDefault([]);

      models.addAll(expenses.map((e) => _toModel(e)));
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

    var expensesResult = await _manageExpense.getAllOf(
      month: month,
      year: year,
      account: account,
    );

    expensesResult.fold((expenses) {
      var models = expenses.map((e) => _toModel(e)).toList();

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
    var filtered = _filterExpenses.byName(models: all, searchName: name);

    update(filtered);
  }

  List<ExpenseModel> filterByCategory(
    List<ExpenseModel> models,
    List<Category> categories,
  ) {
    return _filterExpenses.byCategory(models: models, categories: categories);
  }

  List<ExpenseModel> filterByStatus(
    List<ExpenseModel> models,
    List<Status> status,
  ) {
    return _filterExpenses.byStatus(models: models, status: status);
  }

  List<ExpenseModel> filterByRangeValue(
    List<ExpenseModel> models,
    double min,
    double max,
  ) {
    return _filterExpenses.byRangeValue(models: models, min: min, max: max);
  }

  List<ExpenseModel> sort(
    List<ExpenseModel> models,
    PaiyableSortOption option, {
    bool isCrescent = true,
  }) {
    return switch (option) {
      PaiyableSortOption.byValue => _orderExpenses.byValue(
          models,
          isCrescent: isCrescent,
        ),
      PaiyableSortOption.byName => _orderExpenses.byName(
          models,
          isCrescent: isCrescent,
        ),
      PaiyableSortOption.byDueDate => _orderExpenses.byDueDate(
          models,
          isCrescent: isCrescent,
        ),
    };
  }

  void updateState(List<ExpenseModel> newState) {
    update(newState);
  }

  ExpenseModel _toModel(Expense e) {
    return ExpenseModel.fromExpense(e, status: _determineExpenseStatus(e));
  }

  Status _determineExpenseStatus(Expense e) {
    if (e.remainingValue == 0.00) return Status.okay;

    if (e.dueDate.isBefore(Date.today())) {
      return Status.overdue;
    }

    return Status.inTime;
  }
}
