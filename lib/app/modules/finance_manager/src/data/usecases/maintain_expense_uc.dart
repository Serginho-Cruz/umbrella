import 'package:result_dart/result_dart.dart';
import '../../domain/entities/expense.dart';

import '../../domain/entities/expense_parcel.dart';

import '../../errors/errors.dart';

import '../../domain/usecases/imaintain_expense.dart';
import '../repositories/iexpense_repository.dart';

class MaintainExpenseUC implements IMaintainExpense {
  final IExpenseRepository repository;

  MaintainExpenseUC(this.repository);

  @override
  Future<Result<void, Fail>> register(Expense expense) =>
      repository.create(expense);

  @override
  Future<Result<void, Fail>> update({
    required ExpenseParcel newParcel,
    bool updateExpense = false,
  }) async {
    var updateParcel = await repository.updateParcel(newParcel);

    if (updateParcel.isError()) {
      return updateParcel;
    }

    if (updateExpense) {
      var result = await repository.updateExpense(newParcel.expense);
      return result;
    }

    return updateParcel;
  }

  @override
  Future<Result<List<ExpenseParcel>, Fail>> getAll(int month) =>
      repository.getAll(month);

  @override
  Future<Result<List<ExpenseParcel>, Fail>> getByExpirationDate(int month) =>
      repository.getByExpirationDate(month);

  @override
  Future<Result<void, Fail>> delete({
    required ExpenseParcel parcel,
    bool deleteExpense = false,
  }) async {
    var deleteParcel = await repository.deleteParcel(parcel);

    if (deleteParcel.isError()) {
      return deleteParcel;
    }

    if (deleteExpense) {
      return repository.deleteExpense(parcel.expense);
    }

    return deleteParcel;
  }
}
