import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/frequency.dart';
import '../../errors/errors.dart';

import '../../domain/entities/income.dart';

abstract class IIncomeRepository {
  Future<Result<void, Fail>> create(Income income);
  Future<Result<List<Income>, Fail>> getAll();
  Future<Result<List<Income>, Fail>> getByFrequency(Frequency frequency);
  Future<Result<double, Fail>> getSumOfIncomesWithFrequency(
    Frequency frequency,
  );
  Future<Result<double, Fail>> getSumOfYearlyIncomesInRange({
    required DateTime inferiorLimit,
    required DateTime upperLimit,
  });
  Future<Result<List<String>, Fail>> getPersonsNames();
  Future<Result<void, Fail>> update(Income newIncome);
  Future<Result<void, Fail>> delete(Income income);
}
