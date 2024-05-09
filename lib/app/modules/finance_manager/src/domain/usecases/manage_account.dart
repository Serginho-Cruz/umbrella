import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/auth/src/domain/entities/user.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/account.dart';

import '../../errors/errors.dart';

abstract interface class ManageAccount {
  AsyncResult<int, Fail> register(Account account, User user);
  AsyncResult<Unit, Fail> update(Account newAccount);
  AsyncResult<List<Account>, Fail> getAll(User user);
  AsyncResult<Unit, Fail> delete(Account account);
}
