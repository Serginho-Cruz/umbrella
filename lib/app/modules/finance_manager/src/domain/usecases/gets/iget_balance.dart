import 'package:result_dart/result_dart.dart';

import '../../../errors/errors.dart';

abstract class IGetBalance {
  Future<Result<double, Fail>> get actual;
  Future<Result<double, Fail>> get expected;
  Future<Result<double, Fail>> initialBalanceOf({
    required int month,
    required int year,
  });
  Future<Result<double, Fail>> expectedBalanceOf({
    required int month,
    required int year,
  });
  Future<Result<double, Fail>> finalBalanceOf({
    required int month,
    required int year,
  });
}
