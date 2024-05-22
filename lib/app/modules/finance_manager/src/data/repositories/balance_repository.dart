import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/account.dart';
import '../../errors/errors.dart';

abstract interface class BalanceRepository {
  AsyncResult<Unit, Fail> setInitialOf({
    required Account account,
    required int month,
    required int year,
    required double newValue,
  });
  AsyncResult<Unit, Fail> addToActual(double value, Account account);
  AsyncResult<Unit, Fail> addToExpected(
    double value,
    Account account,
  );
  AsyncResult<Unit, Fail> subtractFromActual(
    double value,
    Account account,
  );
  AsyncResult<Unit, Fail> subtractFromExpected(
    double value,
    Account account,
  );
  AsyncResult<double, Fail> getInitialOf({
    required int month,
    required int year,
    required Account account,
  });
  AsyncResult<double, Fail> getExpectedOf({
    required int month,
    required int year,
    required Account account,
  });
  AsyncResult<double, Fail> getFinalOf({
    required int month,
    required int year,
    required Account account,
  });
}
