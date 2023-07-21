import 'package:result_dart/result_dart.dart';

import '../../domain/entities/expense.dart';
import '../../domain/entities/frequency.dart';
import '../../errors/errors.dart';

abstract class IExpenseRepository {
  Future<Result<void, Fail>> create(Expense expense);
  Future<Result<void, Fail>> update(Expense newExpense);
  Future<Result<List<Expense>, Fail>> getAll();
  Future<Result<List<Expense>, Fail>> getByFrequency(Frequency frequency);
  Future<Result<double, Fail>> getSumOfExpensesWithFrequency(
    Frequency frequency,
  );
  Future<Result<double, Fail>> getSumOfYearlyExpensesInRange({
    required DateTime inferiorLimit,
    required DateTime upperLimit,
  });
  Future<Result<List<String>, Fail>> getPersonsNames();
  Future<Result<void, Fail>> delete(Expense expense);
}
