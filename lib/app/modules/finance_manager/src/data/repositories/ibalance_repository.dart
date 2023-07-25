import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/errors/errors.dart';

abstract class IBalanceRepository {
  Future<Result<void, Fail>> sumToActualBalance(double value);
  Future<Result<void, Fail>> sumToExpectedBalance(double value);
  Future<Result<void, Fail>> decrementFromActualBalance(double value);
  Future<Result<void, Fail>> decrementFromExpectedBalance(double value);
  Future<Result<double, Fail>> getActualBalanceOf({
    required int month,
    required int year,
  });
  Future<Result<double, Fail>> getInitialBalanceOf({
    required int month,
    required int year,
  });
  Future<Result<double, Fail>> getFinalBalanceOf({
    required int month,
    required int year,
  });
  Future<Result<double, Fail>> getExpectedBalanceOf({
    required int month,
    required int year,
  });
}
