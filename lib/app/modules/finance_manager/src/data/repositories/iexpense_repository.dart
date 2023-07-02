import 'package:result_dart/result_dart.dart';

import '../../domain/entities/expense.dart';
import '../../errors/errors.dart';

abstract class IExpenseRepository {
  Future<Result<void, Fail>> create(Expense expense);
  Future<Result<void, Fail>> update(Expense newExpense);
  Future<Result<List<Expense>, Fail>> getAll(int month);
  Future<Result<void, Fail>> delete(Expense expense);
}
