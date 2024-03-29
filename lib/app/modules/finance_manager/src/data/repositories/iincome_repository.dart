import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/date.dart';
import '../../domain/entities/frequency.dart';
import '../../errors/errors.dart';

import '../../domain/entities/income.dart';

abstract class IIncomeRepository {
  Future<Result<int, Fail>> create(Income income);
  Future<Result<List<int>, Fail>> createAll(List<Income> incomes);
  Future<Result<void, Fail>> update(Income newIncome);
  Future<Result<List<Income>, Fail>> getAll();
  Future<Result<List<Income>, Fail>> getAllOf({
    required int month,
    required int year,
  });
  Future<Result<List<Income>, Fail>> getByFrequency(Frequency frequency);
  Future<Result<double, Fail>> getSumOfIncomesWithFrequency(
    Frequency frequency,
  );
  Future<Result<double, Fail>> getSumOfYearlyIncomesInRange({
    required Date inferiorLimit,
    required Date upperLimit,
  });
  Future<Result<List<String>, Fail>> getPersonsNames();
  Future<Result<void, Fail>> delete(Income income);
}
