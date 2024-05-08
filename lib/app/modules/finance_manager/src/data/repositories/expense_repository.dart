import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/auth/src/domain/entities/user.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/date.dart';

import '../../domain/entities/account.dart';
import '../../domain/entities/expense.dart';
import '../../domain/entities/frequency.dart';
import '../../errors/errors.dart';

abstract interface class ExpenseRepository {
  AsyncResult<int, Fail> create(Expense expense, Account account);
  AsyncResult<Unit, Fail> update(
    Expense oldExpense,
    Expense newExpense,
    Account account,
  );
  AsyncResult<List<Expense>, Fail> getAllOf({
    required int year,
    required int month,
    required Account account,
  });
  AsyncResult<List<Expense>, Fail> getByFrequency(
    Frequency frequency,
    Account account,
  );
  AsyncResult<List<Expense>, Fail> getByFrequencyInRange({
    required Date inferiorLimit,
    required Date upperLimit,
    required Frequency frequency,
    required Account account,
  });
  AsyncResult<List<String>, Fail> getPersonsNames(User user);
  AsyncResult<Unit, Fail> delete(Expense expense, Account account);
}
