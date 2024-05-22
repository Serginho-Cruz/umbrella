import 'package:flutter_triple/flutter_triple.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/usecases/manage_income.dart';

import '../../domain/entities/account.dart';
import '../../domain/entities/date.dart';
import '../../domain/models/income_model.dart';

class IncomeStore extends Store<List<IncomeModel>> {
  final ManageIncome _manageIncome;
  final Map<Account, List<IncomeModel>> _allByAccount = {};

  Date _lastDateRequested = Date.today();
  bool _hasAll = false;

  IncomeStore(this._manageIncome) : super([]);

  Future<void> getForAll({
    required List<Account> accounts,
    required int month,
    required int year,
  }) async {
    if (accounts.isEmpty) return;

    setLoading(true);

    if (!_needToFetch(month, year)) {
      update(_allByAccount.values
          .reduce((allIncomes, incomes) => allIncomes..addAll(incomes)));

      setLoading(false);
      return;
    }

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

      var account = accounts[i];

      _allByAccount.update(account, (value) => result.getOrDefault([]),
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

    if (!_needToFetch(month, year) && _allByAccount.containsKey(account)) {
      _lastDateRequested = Date(day: 1, month: month, year: year);
      update(_allByAccount[account]!);
      return;
    }

    var incomesResult = await _manageIncome.getAllOf(
      month: month,
      year: year,
      account: account,
    );

    incomesResult.fold((incomes) {
      _allByAccount.update(account, (_) => incomes, ifAbsent: () => incomes);
      update(incomes);
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
