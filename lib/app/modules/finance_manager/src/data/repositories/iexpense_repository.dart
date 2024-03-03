import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/date.dart';

import '../../domain/entities/expense.dart';
import '../../domain/entities/frequency.dart';
import '../../errors/errors.dart';

abstract class IExpenseRepository {
  Future<Result<int, Fail>> create(Expense expense);
  Future<Result<List<int>, Fail>> createAll(List<Expense> expenses);
  Future<Result<void, Fail>> update(Expense newExpense);
  Future<Result<List<Expense>, Fail>> getAll();
  Future<Result<List<Expense>, Fail>> getAllOf({
    required int year,
    required int month,
  });
  Future<Result<List<Expense>, Fail>> getByFrequency(Frequency frequency);
  Future<Result<double, Fail>> getSumOfExpensesWithFrequency(
    Frequency frequency,
  );
  Future<Result<double, Fail>> getSumOfYearlyExpensesInRange({
    required Date inferiorLimit,
    required Date upperLimit,
  });
  Future<Result<List<String>, Fail>> getPersonsNames();
  Future<Result<void, Fail>> delete(Expense expense);
}
