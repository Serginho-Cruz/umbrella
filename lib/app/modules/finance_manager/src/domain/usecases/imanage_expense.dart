import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/models/expense_model.dart';

import '../../errors/errors.dart';
import '../entities/expense.dart';

abstract class IManageExpense {
  Future<Result<void, Fail>> register(Expense expense);
  Future<Result<void, Fail>> update({
    required Expense oldExpense,
    required Expense newExpense,
  });
  Future<Result<List<ExpenseModel>, Fail>> getAllOf({
    required int month,
    required int year,
  });
  Future<Result<void, Fail>> delete(Expense expense);
}
