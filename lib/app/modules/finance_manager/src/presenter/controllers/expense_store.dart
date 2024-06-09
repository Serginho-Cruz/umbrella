import 'package:flutter_triple/flutter_triple.dart';
import 'package:result_dart/result_dart.dart';

import '../../domain/entities/account.dart';
import '../../domain/entities/date.dart';
import '../../domain/entities/expense.dart';
import '../../domain/models/expense_model.dart';
import '../../domain/usecases/manage_expense.dart';
import '../../errors/errors.dart';

class ExpenseStore extends Store<List<ExpenseModel>> {
  ExpenseStore(this._manageExpense) : super([]);

  final ManageExpense _manageExpense;
  final Map<int, List<ExpenseModel>> _allByAccount = {};

  Date _lastDateRequested = Date.today();
  bool _hasAll = false;

  AsyncResult<int, Fail> register(Expense expense, Account account) async {
    var result = await _manageExpense.register(expense, account);

    if (result.isSuccess()) _hasAll = false;
    return result;
  }

  Future<void> getForAll({
    required List<Account> accounts,
    required int month,
    required int year,
  }) async {
    if (accounts.isEmpty) return;

    setLoading(true);

    if (!_needToFetch(month, year)) {
      update(_allByAccount.values
          .reduce((value, element) => value..addAll(element)));

      setLoading(false);

      return;
    }

    var list = List.generate(
        accounts.length,
        (i) => _manageExpense.getAllOf(
            month: month, year: year, account: accounts[i]));

    var results = await Future.wait(list);

    for (int i = 0; i < accounts.length; i++) {
      var result = results[i];

      if (result.isError()) {
        setError(result.exceptionOrNull()!);
        setLoading(false);

        return;
      }

      var account = accounts[i];

      _allByAccount.update(account.id, (value) => result.getOrDefault([]),
          ifAbsent: () => result.getOrDefault([]));
    }

    _lastDateRequested = Date(day: 1, month: month, year: year);
    _hasAll = true;
    update(_allByAccount.values.reduce((all, list) => all..addAll(list)));
    setLoading(false);
  }

  Future<void> getAllOf({
    required int month,
    required int year,
    required Account account,
  }) async {
    setLoading(true);

    if (!_needToFetch(month, year) && _allByAccount.containsKey(account.id)) {
      _lastDateRequested = Date(day: 1, month: month, year: year);
      update(_allByAccount[account.id]!);
      return;
    }

    var expensesResult = await _manageExpense.getAllOf(
      month: month,
      year: year,
      account: account,
    );

    expensesResult.fold((expenses) {
      _allByAccount.update(account.id, (_) => expenses,
          ifAbsent: () => expenses);
      update(expenses);
    }, (fail) {
      setError(fail);
    });

    _hasAll = false;
    _lastDateRequested = Date(day: 1, month: month, year: year);

    setLoading(false);
  }

  bool _needToFetch(int requestedMonth, int requestedYear) {
    Date requestedDate = Date(
      day: 1,
      month: requestedMonth,
      year: requestedYear,
    );

    if (_lastDateRequested.isAtTheSameMonthAs(requestedDate) && _hasAll) {
      return false;
    }

    return true;
  }
}
