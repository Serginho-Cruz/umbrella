import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/auth/src/domain/entities/user.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/errors/errors.dart';

import '../../domain/entities/account.dart';

abstract interface class AccountRepository {
  AsyncResult<String, Fail> create(Account account, User user);
  AsyncResult<Unit, Fail> update(Account newAccount);
  AsyncResult<Unit, Fail> incrementBalance(Account account, double value);
  AsyncResult<List<Account>, Fail> getAll(User user);
  AsyncResult<Unit, Fail> delete(Account account);
}
