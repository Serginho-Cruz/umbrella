import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/account.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/infra/datasources/balance_datasource.dart';

import '../../domain/entities/date.dart';

class TemporaryBalanceDatasource implements BalanceDatasource {
  final Map<
      int,
      Map<({int month, int year}),
          (double initial, double expected, double? last)>> data = {
    1: {
      (month: 3, year: 2024): (1400.00, 200.00, 700.00),
      (month: 4, year: 2024): (700.00, 200.00, 200.00),
      (month: 5, year: 2024): (200.00, 800.00, null),
    },
    2: {
      (month: 3, year: 2024): (0.00, 600.50, 700.00),
      (month: 4, year: 2024): (700.00, 127.33, 127.33),
      (month: 5, year: 2024): (127.33, 98.21, null),
    },
    3: {
      (month: 3, year: 2024): (0.00, 0.50, 0.50),
      (month: 4, year: 2024): (0.50, 1.00, 1.00),
      (month: 5, year: 2024): (1.0, 0.0, null),
    },
  };

  @override
  Future<void> addToExpected(Account account, double value) async {
    Date today = Date.today();

    var month = (month: today.month, year: today.year);

    var balances = data[account.id]?[month];

    if (balances == null) {
      data.putIfAbsent(account.id,
          () => {(month: today.month, year: today.year): (0.00, value, null)});

      return;
    }

    data[account.id]!.update(month,
        (oldValues) => (oldValues.$1, oldValues.$2 + value, oldValues.$3));
  }

  @override
  Future<double> getExpectedOf({
    required Account account,
    required int month,
    required int year,
  }) {
    var requiredMonth = (month: month, year: year);

    return Future.delayed(
        const Duration(seconds: 1), () => data[account.id]![requiredMonth]!.$2);
  }

  @override
  Future<double> getFinalOf({
    required Account account,
    required int month,
    required int year,
  }) {
    var requiredMonth = (month: month, year: year);

    return Future.delayed(const Duration(seconds: 1),
        () => data[account.id]![requiredMonth]!.$3!);
  }

  @override
  Future<double> getInitialOf({
    required Account account,
    required int month,
    required int year,
  }) {
    var requiredMonth = (month: month, year: year);

    return Future.delayed(
        const Duration(seconds: 1), () => data[account.id]![requiredMonth]!.$1);
  }

  @override
  Future<void> setInitialOf({
    required Account account,
    required double value,
    required int month,
    required int year,
  }) {
    var requiredMonth = (month: month, year: year);

    return Future.delayed(const Duration(seconds: 1), () {
      data[account.id]!.update(requiredMonth, (b) => (value, b.$2, b.$3));
    });
  }

  @override
  Future<void> subtractFromExpected(Account account, double value) async {
    Date today = Date.today();

    var month = (month: today.month, year: today.year);

    var balances = data[account.id]?[month];

    if (balances == null) {
      data.putIfAbsent(account.id,
          () => {(month: today.month, year: today.year): (0.00, value, null)});

      return;
    }

    data[account.id]!.update(month,
        (oldValues) => (oldValues.$1, oldValues.$2 + value, oldValues.$3));
  }
}
