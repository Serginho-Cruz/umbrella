import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/account.dart';
import '../../errors/errors.dart';

abstract interface class BalanceRepository {
  AsyncResult<Unit, Fail> setInitial(double newValue, Account account);
  AsyncResult<Unit, Fail> addToActualBalance(double value, Account account);
  AsyncResult<Unit, Fail> addToExpectedBalance(
    double value,
    Account account,
  );
  AsyncResult<Unit, Fail> subtractFromActualBalance(
    double value,
    Account account,
  );
  AsyncResult<Unit, Fail> subtractFromExpectedBalance(
    double value,
    Account account,
  );
  AsyncResult<double, Fail> getInitialBalanceOf({
    required int month,
    required int year,
    required Account account,
  });
  AsyncResult<double, Fail> getExpectedBalanceOf({
    required int month,
    required int year,
    required Account account,
  });
  AsyncResult<double, Fail> getFinalBalanceOf({
    required int month,
    required int year,
    required Account account,
  });
}
