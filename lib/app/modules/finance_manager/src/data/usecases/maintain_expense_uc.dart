import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/expense.dart';

import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/expense_parcel.dart';

import 'package:umbrella_echonomics/app/modules/finance_manager/src/errors/errors.dart';

import '../../domain/usecases/imaintain_expense.dart';
import '../repositories/iexpense_repository.dart';

class MaintainExpenseUC implements IMaintainExpense {
  final IExpenseRepository repository;

  MaintainExpenseUC(this.repository);

  @override
  Future<Result<void, Fail>> register(Expense expense) {
    // TODO: implement register
    throw UnimplementedError();
  }

  @override
  Future<Result<void, Fail>> update({
    required ExpenseParcel newParcel,
    bool updateExpense = false,
  }) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future<Result<List<ExpenseParcel>, Fail>> getAll(int month) {
    // TODO: implement getAll
    throw UnimplementedError();
  }

  @override
  Future<Result<void, Fail>> delete({
    required ExpenseParcel expense,
    bool deleteExpense = false,
  }) {
    // TODO: implement delete
    throw UnimplementedError();
  }
}
