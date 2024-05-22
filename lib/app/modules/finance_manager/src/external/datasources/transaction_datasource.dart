import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/account.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/paiyable.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/transaction.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/infra/datasources/transaction_datasource.dart';

import '../../domain/entities/date.dart';
import '../../domain/entities/expense.dart';
import '../../domain/entities/income.dart';
import '../../domain/entities/invoice.dart';

class TemporaryTransactionDatasource implements TransactionDatasource {
  final Map<int, List<Transaction>> _data = {};

  @override
  Future<int> register(Transaction transaction, Account account) {
    if (!_data.containsKey(account.id)) {
      _data.putIfAbsent(account.id, () => []);
    }

    int newId;

    var allIds =
        _data.values.map((list) => list.map((t) => t.id).toList()).toList();

    if (allIds.isEmpty) {
      newId = 1;
    } else {
      var ids = allIds.reduce((value, element) => value..addAll(element))
        ..sort();
      newId = ids.last + 1;
    }

    _data.update(account.id, (list) {
      return list..add(transaction.copyWith(id: newId));
    });

    return Future.delayed(const Duration(seconds: 1), () => newId);
  }

  @override
  Future<List<Transaction>> getAllOf({
    required Account account,
    required int month,
    required int year,
  }) {
    if (!_data.containsKey(account.id)) {
      _data.putIfAbsent(account.id, () => []);
    }

    return Future.delayed(const Duration(seconds: 1), () {
      return _data[account.id]!
          .where((transaction) => transaction.paymentDate
              .isAtTheSameMonthAs(Date(day: 1, month: month, year: year)))
          .toList();
    });
  }

  @override
  Future<void> deleteAllOf(Paiyable paiyable) {
    TransactionType type = _determineTypeOf(paiyable);

    for (var key in _data.keys) {
      _data.update(
          key,
          (value) => value
            ..removeWhere((t) =>
                _determineTypeOf(t.paiyable) == type &&
                t.paiyable.id == paiyable.id));
    }

    return Future.delayed(const Duration(seconds: 1));
  }

  TransactionType _determineTypeOf(Paiyable paiyable) {
    return switch (paiyable) {
      Invoice() => TransactionType.invoice,
      Expense() => TransactionType.invoice,
      Income() => TransactionType.invoice,
      Paiyable() => throw UnimplementedError(),
    };
  }
}
