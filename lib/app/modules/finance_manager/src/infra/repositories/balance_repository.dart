import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/balance_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/account.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/errors/errors.dart';

import '../../data/repositories/account_repository.dart';
import '../datasources/balance_datasource.dart';

class BalanceRepositoryImpl implements BalanceRepository {
  final BalanceDatasource _balanceDatasource;
  final AccountRepository _accountRepository;

  BalanceRepositoryImpl({
    required BalanceDatasource balanceDatasource,
    required AccountRepository accountRepository,
  })  : _balanceDatasource = balanceDatasource,
        _accountRepository = accountRepository;

  @override
  AsyncResult<Unit, Fail> addToActual(
    double value,
    Account account,
  ) async {
    var result = await _accountRepository.incrementBalance(account, value);
    return result;
  }

  @override
  AsyncResult<Unit, Fail> addToExpected(
    double value,
    Account account,
  ) async {
    try {
      await _balanceDatasource.addToExpected(account, value);
    } on Fail catch (f) {
      return Failure(f);
    } catch (_) {
      return Failure(GenericError());
    }

    return const Success(unit);
  }

  @override
  AsyncResult<double, Fail> getExpectedOf({
    required int month,
    required int year,
    required Account account,
  }) async {
    try {
      var balance = await _balanceDatasource.getExpectedOf(
        account: account,
        month: month,
        year: year,
      );

      return Success(balance);
    } on Fail catch (f) {
      return Failure(f);
    } catch (_) {
      return Failure(GenericError());
    }
  }

  @override
  AsyncResult<double, Fail> getFinalOf({
    required int month,
    required int year,
    required Account account,
  }) async {
    try {
      var balance = await _balanceDatasource.getFinalOf(
        account: account,
        month: month,
        year: year,
      );

      return Success(balance);
    } on Fail catch (f) {
      return Failure(f);
    } catch (_) {
      return Failure(GenericError());
    }
  }

  @override
  AsyncResult<double, Fail> getInitialOf({
    required int month,
    required int year,
    required Account account,
  }) async {
    try {
      var balance = await _balanceDatasource.getInitialOf(
        account: account,
        month: month,
        year: year,
      );

      return Success(balance);
    } on Fail catch (f) {
      return Failure(f);
    } catch (_) {
      return Failure(GenericError());
    }
  }

  @override
  AsyncResult<Unit, Fail> setInitialOf({
    required Account account,
    required double newValue,
    required int month,
    required int year,
  }) async {
    try {
      await _balanceDatasource.setInitialOf(
        account: account,
        value: newValue,
        month: month,
        year: year,
      );
    } on Fail catch (f) {
      return Failure(f);
    } catch (_) {
      return Failure(GenericError());
    }

    return const Success(unit);
  }

  @override
  AsyncResult<Unit, Fail> subtractFromActual(
    double value,
    Account account,
  ) async {
    var result = await _accountRepository.incrementBalance(account, value * -1);
    return result;
  }

  @override
  AsyncResult<Unit, Fail> subtractFromExpected(
    double value,
    Account account,
  ) async {
    try {
      await _balanceDatasource.subtractFromExpected(account, value);
    } on Fail catch (f) {
      return Failure(f);
    } catch (_) {
      return Failure(GenericError());
    }

    return const Success(unit);
  }
}
