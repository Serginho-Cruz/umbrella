import 'package:result_dart/result_dart.dart';

import '../../errors/errors.dart';
import '../entities/expense.dart';
import '../entities/expense_parcel.dart';

abstract class IManageExpense {
  Future<Result<void, Fail>> register(Expense expense);
  Future<Result<void, Fail>> update({
    required ExpenseParcel newParcel,
    bool updateExpense = false,
  });
  Future<Result<List<ExpenseParcel>, Fail>> getAllOf({
    required int month,
    required int year,
  });
  Future<Result<void, Fail>> delete({
    required ExpenseParcel parcel,
    bool deleteExpense = false,
  });
}
