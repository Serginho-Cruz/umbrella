import 'package:mobx/mobx.dart';
import 'package:umbrella_echonomics/app/modules/auth/src/domain/entities/user_state.dart'
    as user;
import 'package:umbrella_echonomics/app/modules/auth/src/presenter/stores/auth_store.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/errors/generic_messages.dart';

import '../../domain/entities/account.dart';
import '../../domain/states/state.dart';
import '../../domain/usecases/manage_account.dart';
import '../../errors/errors.dart';
part 'account_store.g.dart';

class AccountStore = _AccountStoreBase with _$AccountStore;

abstract class _AccountStoreBase with Store {
  final ManageAccount _manageAccount;
  final AuthStore _authStore;

  @observable
  State<List<Account>> state = const InitialState<List<Account>>();

  @observable
  ObservableList<Account> visualizingAccounts = ObservableList();

  @observable
  Account? selectedAccount;

  ReactionDisposer? _autoUpdater;
  ReactionDisposer? _userReaction;

  @observable
  bool _needsFetch = false;

  _AccountStoreBase({
    required ManageAccount manageAccount,
    required AuthStore authStore,
  })  : _manageAccount = manageAccount,
        _authStore = authStore {
    _setUpReactions();
  }

  @action
  Future<void> create() async {
    _needsFetch = true;
  }

  @action
  Future<void> updateAccount() async {
    _needsFetch = true;
  }

  @action
  Future<void> get({bool force = false}) async {
    if (state is SuccessState && !force) return;

    state = const LoadingState();
    await _fetchAccounts();
    _needsFetch = false;
  }

  @action
  void changeSelectedAccount(Account? account) {
    if (state is! SuccessState) return;

    selectedAccount = account;

    if (account == null) {
      visualizingAccounts
        ..clear()
        ..addAll((state as SuccessState<List<Account>>).state);
      return;
    }

    visualizingAccounts
      ..clear()
      ..add(account);
  }

  @action
  Future<void> delete() async {
    _needsFetch = true;
  }

  @action
  Future<void> _fetchAccounts() async {
    if (_authStore.state is! user.SuccessState) {
      state = const FailState(Fail(GenericMessages.userUnlogged));
      return;
    }

    //Now is safe
    var loggedUserState = _authStore.state as user.SuccessState;

    var result = await _manageAccount.getAll(loggedUserState.user);

    state = result.fold(
      (accs) => SuccessState(accs),
      (fail) => FailState(fail),
    );

    _updateVisualizingAccountsOnFetch();
  }

  @action
  void _updateVisualizingAccountsOnFetch() {
    if (state is! SuccessState) {
      visualizingAccounts.clear();
      return;
    }

    var stateAccs = state as SuccessState<List<Account>>;
    if (visualizingAccounts.length != 1) {
      visualizingAccounts
        ..clear()
        ..addAll(stateAccs.state);

      return;
    } else {
      String accId = visualizingAccounts.first.id;

      Account? found;

      for (var acc in stateAccs.state) {
        if (acc.id != accId) continue;
        found = acc;
        break;
      }

      if (found != visualizingAccounts.first && found != null) {
        visualizingAccounts
          ..clear()
          ..add(found);
      } else if (found == null) {
        visualizingAccounts
          ..clear()
          ..addAll(stateAccs.state);
      }
    }
  }

  void _setUpReactions() {
    _autoUpdater = autorun((_) {
      if (_needsFetch == true) get(force: true);
    });

    _userReaction = autorun((_) {
      if (_authStore.state is! user.SuccessState) _restartStates();
    });
  }

  @action
  void _restartStates() {
    state = const InitialState();
    visualizingAccounts.clear();
  }

  void dispose() {
    _userReaction?.call();
    _autoUpdater?.call();
  }
}
