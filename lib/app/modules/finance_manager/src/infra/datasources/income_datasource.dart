import '../../domain/entities/account.dart';
import '../../domain/entities/date.dart';
import '../../domain/entities/frequency.dart';
import '../../domain/entities/income.dart';

abstract interface class IncomeDatasource {
  Future<int> create(Income income, Account account);
  Future<void> update(Income newIncome);
  Future<List<Income>> getAllOf({
    required Account account,
    required int month,
    required int year,
  });
  Future<List<Income>> getByFrequency(Frequency frequency, Account account);
  Future<List<Income>> getByFrequencyInRange({
    required Date inferiorLimit,
    required Date upperLimit,
    required Frequency frequency,
    required Account account,
  });

  Future<void> delete(Income income);
}
