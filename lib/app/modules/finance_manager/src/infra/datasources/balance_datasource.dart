import '../../domain/entities/account.dart';

abstract interface class BalanceDatasource {
  Future<void> addToExpected(Account account, double value);
  Future<void> subtractFromExpected(Account account, double value);
  Future<double> getInitialOf({
    required Account account,
    required int month,
    required int year,
  });
  Future<double> getExpectedOf({
    required Account account,
    required int month,
    required int year,
  });
  Future<double> getFinalOf({
    required Account account,
    required int month,
    required int year,
  });
  Future<void> setInitialOf({
    required Account account,
    required double value,
    required int month,
    required int year,
  });
}
