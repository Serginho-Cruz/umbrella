import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/auth/src/domain/entities/user.dart';

import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/account.dart';

import 'package:umbrella_echonomics/app/modules/finance_manager/src/errors/errors.dart';

import '../../domain/usecases/manage_account.dart';
import '../repositories/account_repository.dart';

class ManageAccountImpl implements ManageAccount {
  final AccountRepository _repository;

  ManageAccountImpl(this._repository);

  @override
  AsyncResult<int, Fail> register(Account account, User user) async {
    var result = await _repository.create(account, user);
    return result;
  }

  @override
  AsyncResult<Unit, Fail> update(Account oldAccount, Account newAccount) async {
    if (oldAccount == newAccount) {
      return const Success(unit);
    }
    var result = await _repository.update(newAccount);
    return result;
  }

  @override
  AsyncResult<List<Account>, Fail> getAll(User user) async {
    var result = await _repository.getAll(user);
    return result;
  }

  @override
  AsyncResult<Unit, Fail> delete(Account account) async {
    var result = await _repository.delete(account);
    return result;
  }
}
