import 'package:flutter_triple/flutter_triple.dart';
import 'package:umbrella_echonomics/app/modules/auth/src/presenter/controllers/auth_controller.dart';

import '../../domain/entities/account.dart';
import '../../domain/usecases/manage_account.dart';

class AccountStore extends Store<List<Account>> {
  AccountStore({
    required ManageAccount manageAccount,
    required AuthController authController,
  })  : _manageAccount = manageAccount,
        _authController = authController,
        super([]);

  final ManageAccount _manageAccount;
  final AuthController _authController;
  Account? selectedAccount;

  bool _hasAll = false;

  Future<void> create(Account account) async {}

  Future<void> updateAccount(Account oldAccount, Account newAccount) async {}

  Future<void> getAll() async {
    if (!_authController.isLogged || _hasAll) return;

    setLoading(true);
    var user = _authController.user!;

    var result = await _manageAccount.getAll(user);

    result.fold((success) {
      _hasAll = true;
      update(success);
    }, (failure) {
      setError(failure);
    });

    setLoading(false);
  }

  Future<void> delete() async {}
}
