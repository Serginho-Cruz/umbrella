import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/account.dart';

import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/date.dart';

import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/frequency.dart';

import 'package:umbrella_echonomics/app/modules/finance_manager/src/errors/errors.dart';

import '../../data/repositories/income_repository.dart';
import '../../domain/entities/income.dart';
import '../datasources/income_datasource.dart';

class IncomeRepositoryImpl implements IncomeRepository {
  final IncomeDatasource _datasource;

  IncomeRepositoryImpl(this._datasource);

  @override
  AsyncResult<int, Fail> create(Income income) async {
    try {
      var newid = await _datasource.create(income);
      return Success(newid);
    } on Fail catch (f) {
      return Failure(f);
    } catch (e) {
      return Failure(GenericError());
    }
  }

  @override
  AsyncResult<Unit, Fail> update(Income newIncome) async {
    try {
      await _datasource.update(newIncome);
      return const Success(unit);
    } on Fail catch (f) {
      return Failure(f);
    } catch (e) {
      return Failure(GenericError());
    }
  }

  @override
  AsyncResult<List<Income>, Fail> getAllOf({
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
  AsyncResult<List<Income>, Fail> getByFrequency(
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
  AsyncResult<List<Income>, Fail> getByFrequencyInRange({
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
  AsyncResult<Unit, Fail> delete(Income income) async {
    try {
      await _datasource.delete(income);
      return const Success(unit);
    } on Fail catch (f) {
      return Failure(f);
    } catch (e) {
      return Failure(GenericError());
    }
  }
}
