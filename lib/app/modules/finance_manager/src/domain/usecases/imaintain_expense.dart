import 'package:result_dart/result_dart.dart';

import '../../errors/errors.dart';
import '../entities/expense.dart';
import '../entities/expense_parcel.dart';

abstract class IMaintainExpense {
  Future<Result<void, Fail>> register(Expense expense);

  Future<Result<void, Fail>> update({
    required ExpenseParcel newParcel,
    bool updateExpense = false,
  });

  Future<Result<List<ExpenseParcel>, Fail>> getAll(int month);

  Future<Result<void, Fail>> delete({
    required ExpenseParcel expense,
    bool deleteExpense = false,
  });
}
