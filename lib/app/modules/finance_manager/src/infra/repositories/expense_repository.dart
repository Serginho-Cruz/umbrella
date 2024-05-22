import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/account.dart';

import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/date.dart';

import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/expense.dart';

import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/frequency.dart';

import 'package:umbrella_echonomics/app/modules/finance_manager/src/errors/errors.dart';

import '../../data/repositories/expense_repository.dart';
import '../datasources/expense_datasource.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final ExpenseDatasource _datasource;

  ExpenseRepositoryImpl(this._datasource);

  @override
  AsyncResult<int, Fail> create(Expense expense, Account account) async {
    try {
      var newid = await _datasource.create(expense, account);
      return Success(newid);
    } on Fail catch (f) {
      return Failure(f);
    } catch (e) {
      return Failure(GenericError());
    }
  }

  @override
  AsyncResult<Unit, Fail> update(Expense newExpense) async {
    try {
      await _datasource.update(newExpense);
      return const Success(unit);
    } on Fail catch (f) {
      return Failure(f);
    } catch (e) {
      return Failure(GenericError());
    }
  }

  @override
  AsyncResult<List<Expense>, Fail> getAllOf({
    required int year,
    required int month,
    required Account account,
  }) async {
    try {
      var expenses = await _datasource.getAllOf(
        month: month,
        year: year,
        account: account,
      );

      return Success(expenses);
    } on Fail catch (f) {
      return Failure(f);
    } catch (e) {
      return Failure(GenericError());
    }
  }

  @override
  AsyncResult<List<Expense>, Fail> getByFrequency(
    Frequency frequency,
    Account account,
  ) async {
    try {
      var expenses = await _datasource.getByFrequency(frequency, account);
      return Success(expenses);
    } on Fail catch (f) {
      return Failure(f);
    } catch (e) {
      return Failure(GenericError());
    }
  }

  @override
  AsyncResult<List<Expense>, Fail> getByFrequencyInRange({
    required Date inferiorLimit,
    required Date upperLimit,
    required Frequency frequency,
    required Account account,
  }) async {
    try {
      var expenses = await _datasource.getByFrequencyInRange(
        frequency: frequency,
        account: account,
        inferiorLimit: inferiorLimit,
        upperLimit: upperLimit,
      );

      return Success(expenses);
    } on Fail catch (f) {
      return Failure(f);
    } catch (e) {
      return Failure(GenericError());
    }
  }

  @override
  AsyncResult<Unit, Fail> delete(Expense expense) async {
    try {
      await _datasource.delete(expense);
      return const Success(unit);
    } on Fail catch (f) {
      return Failure(f);
    } catch (e) {
      return Failure(GenericError());
    }
  }
}
