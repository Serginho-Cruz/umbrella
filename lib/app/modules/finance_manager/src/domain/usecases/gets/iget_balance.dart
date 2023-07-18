import 'package:result_dart/result_dart.dart';

import '../../../errors/errors.dart';

abstract class IGetBalance {
  Future<Result<double, Fail>> get actual;
  Future<Result<double, Fail>> get expected;
  Future<Result<double, Fail>> initialBalanceOf(DateTime month);
  Future<Result<double, Fail>> expectedBalanceOf(DateTime month);
  Future<Result<double, Fail>> finalBalanceOf(DateTime month);
}
