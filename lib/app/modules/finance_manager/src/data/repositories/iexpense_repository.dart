import 'package:result_dart/result_dart.dart';

import '../../domain/entities/expense.dart';
import '../../domain/entities/expense_parcel.dart';
import '../../errors/errors.dart';

abstract class IExpenseRepository {
  Future<Result<void, Fail>> create(Expense expense);
  Future<Result<void, Fail>> updateExpense(Expense newExpense);
  Future<Result<void, Fail>> updateParcel(ExpenseParcel newParcel);
  Future<Result<List<ExpenseParcel>, Fail>> getAll(int month);
  Future<Result<List<ExpenseParcel>, Fail>> getByExpirationDate(int month);
  Future<Result<List<ExpenseParcel>, Fail>> getFirstWeekParcelsOf(int month);
  Future<Result<List<ExpenseParcel>, Fail>> getWhereExpiresOn(DateTime dTime);
  Future<Result<void, Fail>> deleteExpense(Expense expense);
  Future<Result<void, Fail>> deleteParcel(ExpenseParcel expenseParcel);
}
