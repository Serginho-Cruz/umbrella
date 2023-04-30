import 'package:result_dart/result_dart.dart';

import '../../errors/errors.dart';

abstract class IGetBalance {
  Future<Result<double, Fail>> get actual;
  Future<Result<double, Fail>> get expected;
  Future<Result<double, Fail>> getInitialBalanceOf(int month);
  Future<Result<double, Fail>> getExpectedBalanceOf(int month);
  Future<Result<double, Fail>> getFinalBalanceOf(int month);
}
