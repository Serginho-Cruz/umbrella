import 'package:result_dart/result_dart.dart';

import '../../errors/errors.dart';
import '../entities/expense.dart';
import '../entities/expense_parcel.dart';

abstract class IManageExpense {
  Future<Result<void, Fail>> register(Expense expense);
  Future<Result<void, Fail>> updateExpense(Expense expense);
  Future<Result<void, Fail>> updateParcel({
    required ExpenseParcel oldParcel,
    required ExpenseParcel newParcel,
  });
  Future<Result<List<ExpenseParcel>, Fail>> getAllOf({
    required int month,
    required int year,
  });
  Future<Result<void, Fail>> deleteExpense(Expense expense);
  Future<Result<void, Fail>> deleteParcel(ExpenseParcel parcel);
}
