import 'package:result_dart/result_dart.dart';

import '../../errors/errors.dart';
import '../entities/income.dart';

abstract class IReceiveIncome {
  Future<Result<void, Fail>> call({
    required Income income,
    required double value,
  });
  Future<Result<void, Fail>> advanceIncome({
    required Income income,
    required double valueToAdvance,
  });
}
