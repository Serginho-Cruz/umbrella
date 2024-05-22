import 'package:umbrella_echonomics/app/modules/auth/src/domain/entities/user.dart';

import '../../domain/entities/account.dart';
import '../../domain/entities/paiyable.dart';

abstract interface class AccountDatasource {
  Future<int> create(Account account, User user);
  Future<void> update(Account newAccount);
  Future<List<Account>> getAllOf(User user);
  Future<Account> getOfPaiyable(Paiyable paiyable);
  Future<void> delete(Account account);
}
