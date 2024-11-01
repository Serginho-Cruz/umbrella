import 'package:flutter_triple/flutter_triple.dart';
import 'package:umbrella_echonomics/app/modules/auth/src/domain/entities/user_state.dart';
import 'package:umbrella_echonomics/app/modules/auth/src/presenter/stores/auth_store.dart';

import '../../domain/entities/account.dart';
import '../../domain/usecases/manage_account.dart';

class AccountStore extends Store<List<Account>> {
  AccountStore({
    required ManageAccount manageAccount,
    required AuthStore authStore,
  })  : _manageAccount = manageAccount,
        _authStore = authStore,
        super([]);

  final ManageAccount _manageAccount;
  final AuthStore _authStore;

  Account? _selectedAccount;

  final List<void Function(Account?)> _selectedAccountListeners = [];

  Future<void> create(Account account) async {}

  Future<void> updateAccount(Account oldAccount, Account newAccount) async {}

  Future<void> getAll({bool force = false}) async {
    if (_authStore.state is! SuccessState) return;

    if (force == false && state.isNotEmpty) return;

    setLoading(true);
    var user = (_authStore.state as SuccessState).user;

    var result = await _manageAccount.getAll(user);

    result.fold((success) {
      update(success, force: true);
    }, (failure) {
      setError(failure);
    });

    setLoading(false);
  }

  Future<void> delete() async {}

  void addSelectedAccountListener(void Function(Account?) listener) {
    _selectedAccountListeners.add(listener);
  }

  void removeSelectedAccountListener(void Function(Account?) listener) {
    _selectedAccountListeners.remove(listener);
  }

  Account? get selectedAccount => _selectedAccount?.copyWith();

  void changeSelectedAccount(Account? account) {
    if (_selectedAccount?.id == account?.id) return;

    _selectedAccount = account?.copyWith();

    for (var listener in _selectedAccountListeners) {
      listener(account);
    }
  }
}
