import 'package:result_dart/result_dart.dart';

import '../../errors/errors.dart';

abstract class IGetBalance {
  Result<double, Fail> get actual;
  Result<double, Fail> get expected;
  Result<double, Fail> getInitialBalanceOf(int month);
  Result<double, Fail> getExpectedBalanceOf(int month);
  Result<double, Fail> getFinalBalanceOf(int month);
}
