import 'package:umbrella_echonomics/app/modules/auth/src/domain/entities/user.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/account.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/paiyable.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/errors/errors.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/infra/datasources/account_datasource.dart';

import '../../errors/account_error_messages.dart';

class TemporaryAccountDatasource implements AccountDatasource {
  final List<Account> _accounts = [
    const Account(
      id: 1,
      name: 'Conta Padrão',
      actualBalance: 0.00,
      isDefault: true,
    ),
    const Account(id: 2, name: 'Banco do Brasil', actualBalance: 200.00),
    const Account(id: 3, name: 'Itaú', actualBalance: 156.32),
  ];

  @override
  Future<int> create(Account account, User user) {
    return Future.delayed(const Duration(seconds: 2), () {
      int newId = _accounts.last.id + 1;

      _accounts.add(account.copyWith(id: newId));
      return newId;
    });
  }

  @override
  Future<void> update(Account newAccount) async {
    bool wasFound = false;

    for (int i = 0; i < _accounts.length; i++) {
      var acc = _accounts.elementAt(i);
      if (acc == newAccount) {
        Future.delayed(const Duration(seconds: 2), () {
          _accounts.removeAt(i);
          _accounts.insert(i, newAccount);
        });

        wasFound = true;
        break;
      }
    }

    if (!wasFound) {
      throw AccountDoesntExist(AccountMessages.oldAccountNotFound);
    }
  }

  @override
  Future<List<Account>> getAllOf(User user) {
    return Future.delayed(const Duration(seconds: 2), () {
      return _accounts;
    });
  }

  @override
  Future<Account> getOfPaiyable(Paiyable paiyable) {
    return Future.delayed(const Duration(seconds: 1), () {
      return _accounts.first;
    });
  }

  @override
  Future<void> delete(Account account) async {
    bool wasFound = false;

    for (int i = 0; i < _accounts.length; i++) {
      var acc = _accounts.elementAt(i);
      if (acc == account) {
        Future.delayed(const Duration(seconds: 2), () {
          _accounts.removeAt(i);
        });

        wasFound = true;
        break;
      }
    }

    if (!wasFound) {
      throw AccountDoesntExist(AccountMessages.accountNotFoundForDelete);
    }
  }
}
