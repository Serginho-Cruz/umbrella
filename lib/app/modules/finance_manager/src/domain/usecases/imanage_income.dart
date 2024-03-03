import 'package:result_dart/result_dart.dart';

import '../../errors/errors.dart';
import '../entities/income.dart';

abstract class IManageIncome {
  Future<Result<void, Fail>> register(Income income);
  Future<Result<void, Fail>> update({
    required Income oldIncome,
    required Income newIncome,
  });

  Future<Result<List<Income>, Fail>> getAllOf({
    required int month,
    required int year,
  });
  Future<Result<void, Fail>> delete(Income income);
}
