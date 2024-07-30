import 'package:flutter_triple/flutter_triple.dart';

import '../../domain/entities/account.dart';
import '../../domain/usecases/gets/get_balance.dart';

class BalanceStore
    extends Store<(double initial, double expected, double last)> {
  BalanceStore(this._getBalance) : super((0.00, 0.00, 0.00));

  final GetBalance _getBalance;

  Future<void> get({
    required int month,
    required int year,
    required Account account,
  }) async {
    if (isLoading) return;

    setLoading(true);

    var balances = await Future.wait([
      _getBalance.initialOf(month: month, year: year, account: account),
      _getBalance.expectedOf(month: month, year: year, account: account),
      _getBalance.finalOf(month: month, year: year, account: account),
    ]);

    if (balances.any((result) => result.isError())) {
      setError(balances.firstWhere((r) => r.isError()).exceptionOrNull()!);
      return;
    }

    var [initialResult, expectedResult, finalResult] = balances;

    var initial = initialResult.getOrDefault(0.00);
    var expected = expectedResult.getOrDefault(0.00);
    var last = finalResult.getOrDefault(0.00);

    update((initial, expected, last), force: true);

    setLoading(false);
  }

  Future<void> getForAll({
    required int month,
    required int year,
    required List<Account> accounts,
  }) async {
    if (isLoading) return;

    setLoading(true);

    double initial = 0.00, expected = 0.00, last = 0.00;

    for (var account in accounts) {
      var balances = await Future.wait([
        _getBalance.initialOf(month: month, year: year, account: account),
        _getBalance.expectedOf(month: month, year: year, account: account),
        _getBalance.finalOf(month: month, year: year, account: account),
      ]);

      if (balances.any((result) => result.isError())) {
        setError(balances.firstWhere((r) => r.isError()).exceptionOrNull());
        setLoading(false);
        return;
      }

      var [initialResult, expectedResult, finalResult] = balances;

      initial += initialResult.getOrDefault(0.00);
      expected += expectedResult.getOrDefault(0.00);
      last += finalResult.getOrDefault(0.00);
    }

    update((initial, expected, last), force: true);

    setLoading(false);
  }
}
