import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/auth/src/domain/entities/user.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/account_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/account.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/paiyable.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/errors/errors.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/utils/extensions.dart';

import '../datasources/account_datasource.dart';

class AccountRepositoryImpl implements AccountRepository {
  final AccountDatasource _datasource;

  AccountRepositoryImpl(this._datasource);

  @override
  AsyncResult<int, Fail> create(Account account, User user) async {
    try {
      var result = await _datasource.create(account, user);
      return Success(result);
    } on Fail catch (f) {
      return Failure(f);
    } catch (e) {
      return Failure(GenericError());
    }
  }

  @override
  AsyncResult<Unit, Fail> update(Account newAccount) async {
    try {
      await _datasource.update(newAccount);
      return const Success(unit);
    } on Fail catch (f) {
      return Failure(f);
    } catch (e) {
      return Failure(GenericError());
    }
  }

  @override
  AsyncResult<List<Account>, Fail> getAll(User user) async {
    try {
      var result = await _datasource.getAllOf(user);
      return Success(result);
    } on Fail catch (f) {
      return Failure(f);
    } catch (e) {
      return Failure(GenericError());
    }
  }

  @override
  AsyncResult<Account, Fail> getOfPaiyable(Paiyable paiyable) async {
    try {
      var result = await _datasource.getOfPaiyable(paiyable);
      return Success(result);
    } on Fail catch (f) {
      return Failure(f);
    } catch (e) {
      return Failure(GenericError());
    }
  }

  @override
  AsyncResult<Unit, Fail> delete(Account account) async {
    try {
      await _datasource.delete(account);
      return const Success(unit);
    } on Fail catch (f) {
      return Failure(f);
    } catch (e) {
      return Failure(GenericError());
    }
  }

  @override
  AsyncResult<Unit, Fail> incrementBalance(
    Account account,
    double value,
  ) async {
    var result = await update(account.copyWith(
        actualBalance: (account.actualBalance + value).roundToDecimal()));

    return result;
  }
}
