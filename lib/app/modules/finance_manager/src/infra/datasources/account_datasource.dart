import 'package:umbrella_echonomics/app/modules/auth/src/domain/entities/user.dart';

import '../../domain/entities/account.dart';

abstract interface class AccountDatasource {
  Future<String> create(Account account, User user);
  Future<void> update(Account newAccount);
  Future<List<Account>> getAllOf(User user);
  Future<void> delete(Account account);
}
