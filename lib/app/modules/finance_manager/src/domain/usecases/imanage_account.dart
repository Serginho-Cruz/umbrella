import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/account.dart';

import '../../errors/errors.dart';

abstract class IManageAccount {
  Future<Result<void, Fail>> register(Account account);
  Future<Result<void, Fail>> update(Account newAccount);
  Future<Result<List<Account>, Fail>> getAll();
  Future<Result<void, Fail>> delete(Account account);
}
