import 'package:result_dart/result_dart.dart';
import '../../errors/errors.dart';

import '../../domain/entities/income.dart';

abstract class IIncomeRepository {
  Future<Result<void, Fail>> create(Income income);
  Future<Result<List<Income>, Fail>> getAll(int month);
  Future<Result<void, Fail>> update(Income newIncome);
  Future<Result<void, Fail>> delete(Income income);
}
