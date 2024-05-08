import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/auth/src/domain/entities/user.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/date.dart';
import '../../domain/entities/account.dart';
import '../../domain/entities/frequency.dart';

import '../../domain/entities/income.dart';
import '../../errors/errors.dart';

abstract interface class IncomeRepository {
  AsyncResult<int, Fail> create(Income income, Account account);
  AsyncResult<Unit, Fail> update(
    Income oldIncome,
    Income newIncome,
    Account account,
  );
  AsyncResult<List<Income>, Fail> getAllOf({
    required int month,
    required int year,
    required Account account,
  });
  AsyncResult<List<Income>, Fail> getByFrequency(
    Frequency frequency,
    Account account,
  );
  AsyncResult<double, Fail> getByFrequencyInRange({
    required Frequency frequency,
    required Date inferiorLimit,
    required Date upperLimit,
    required Account account,
  });
  AsyncResult<List<String>, Fail> getPersonsNames(User user);
  AsyncResult<Unit, Fail> delete(Income income, Account account);
}
