import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/controllers/paiyable_store.dart';

import '../../domain/entities/account.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/credit_card.dart';
import '../../domain/entities/date.dart';
import '../../domain/entities/expense.dart';
import '../../domain/entities/payment.dart';
import '../../domain/models/expense_model.dart';
import '../../domain/models/status.dart';
import '../../domain/usecases/filters/filter_expenses.dart';
import '../../domain/usecases/manage_expense.dart';
import '../../domain/usecases/sorts/sort_expenses.dart';
import '../../errors/errors.dart';

class ExpenseStore extends PaiyableStore<Expense, ExpenseModel> {
  ExpenseStore({
    required ManageExpense manageExpense,
    required FilterExpenses filterExpenses,
    required SortExpenses sortExpenses,
  })  : _manageExpense = manageExpense,
        _filterExpenses = filterExpenses,
        _sortExpenses = sortExpenses,
        super([]);

  final ManageExpense _manageExpense;
  final FilterExpenses _filterExpenses;
  final SortExpenses _sortExpenses;

  final List<ExpenseModel> all = [];

  @override
  AsyncResult<int, Fail> register(Expense entity) async {
    var result = await _manageExpense.register(entity);

    return result;
  }

  @override
  AsyncResult<void, Fail> updateValue(
    ExpenseModel paiyable,
    double newValue,
  ) =>
      _manageExpense.updateValue(paiyable.toEntity(), newValue);

  @override
  AsyncResult<void, Fail> switchAccount(
    ExpenseModel paiyable,
    Account newAccount,
  ) =>
      _manageExpense.switchAccount(paiyable.toEntity(), newAccount);

  @override
  AsyncResult<void, Fail> edit({
    required Expense oldPaiyable,
    required Expense newPaiyable,
  }) =>
      _manageExpense.update(
        oldExpense: oldPaiyable,
        newExpense: newPaiyable,
      );

  @override
  Future<void> getForAll({
    required List<Account> accounts,
    required int month,
    required int year,
  }) async {
    if (accounts.isEmpty || isLoading) return;

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

  @override
  Future<void> getAllOf({
    required int month,
    required int year,
    required Account account,
  }) async {
    if (isLoading) return;

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

  @override
  AsyncResult<void, Fail> pay({
    required List<Payment<Expense>> payments,
    CreditCard? card,
  }) async {
    return const Success(2);
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
      PaiyableSortOption.byValue => _sortExpenses.byValue(
          models,
          isCrescent: isCrescent,
        ),
      PaiyableSortOption.byName => _sortExpenses.byName(
          models,
          isCrescent: isCrescent,
        ),
      PaiyableSortOption.byDueDate => _sortExpenses.byDueDate(
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
