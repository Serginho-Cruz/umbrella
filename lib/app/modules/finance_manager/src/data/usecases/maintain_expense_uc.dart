import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/iexpense_parcel_repository.dart';
import '../../domain/entities/expense.dart';

import '../../domain/entities/expense_parcel.dart';

import '../../errors/errors.dart';

import '../../domain/usecases/imaintain_expense.dart';
import '../repositories/iexpense_repository.dart';

class MaintainExpenseUC implements IMaintainExpense {
  final IExpenseRepository expenseRepository;
  final IExpenseParcelRepository expenseParcelRepository;

  MaintainExpenseUC({
    required this.expenseRepository,
    required this.expenseParcelRepository,
  });

  @override
  Future<Result<void, Fail>> register(Expense expense) =>
      expenseRepository.create(expense);

  @override
  Future<Result<void, Fail>> update({
    required ExpenseParcel newParcel,
    bool updateExpense = false,
  }) async {
    var updateParcel = await expenseParcelRepository.update(newParcel);

    if (updateParcel.isError()) {
      return updateParcel;
    }

    if (updateExpense) {
      var result = await expenseRepository.update(newParcel.expense);
      return result;
    }

    return updateParcel;
  }

  @override
  Future<Result<List<ExpenseParcel>, Fail>> getAll(int month) =>
      expenseParcelRepository.getAll(month);

  @override
  Future<Result<List<ExpenseParcel>, Fail>> getByExpirationDate(int month) =>
      expenseParcelRepository.getByExpirationDate(month);

  @override
  Future<Result<void, Fail>> delete({
    required ExpenseParcel parcel,
    bool deleteExpense = false,
  }) async {
    var deleteParcel = await expenseParcelRepository.delete(parcel);

    if (deleteParcel.isError()) {
      return deleteParcel;
    }

    if (deleteExpense) {
      return expenseRepository.delete(parcel.expense);
    }

    return deleteParcel;
  }
}
