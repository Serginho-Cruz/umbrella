import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/iexpense_parcel_repository.dart';
import '../../domain/entities/expense.dart';

import '../../domain/entities/expense_parcel.dart';

import '../../errors/errors.dart';

import '../../domain/usecases/imanage_expense.dart';
import '../repositories/iexpense_repository.dart';

class ManageExpense implements IManageExpense {
  final IExpenseRepository expenseRepository;
  final IExpenseParcelRepository expenseParcelRepository;

  ManageExpense({
    required this.expenseRepository,
    required this.expenseParcelRepository,
  });

  @override
  Future<Result<void, Fail>> delete({
    required ExpenseParcel parcel,
    bool deleteExpense = false,
  }) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<Result<List<ExpenseParcel>, Fail>> getAllOf(DateTime month) {
    // TODO: implement getAllOf
    throw UnimplementedError();
  }

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
}
