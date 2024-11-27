import 'package:mobx/mobx.dart';
import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/utils/round.dart';

import '../../domain/entities/account.dart';
import '../../domain/states/state.dart';
import '../../domain/usecases/gets/get_balance.dart';
import '../../errors/errors.dart';
import 'account_store.dart';
import 'expense_store.dart';
import 'income_store.dart';
import 'month_store.dart';
part 'balance_store.g.dart';

class BalanceStore = _BalanceStoreBase with _$BalanceStore;

typedef _DoubleResult = Future<Result<double, Fail>>;

abstract class _BalanceStoreBase with Store {
  final GetBalance _usecase;
  final MonthStore _monthStore;
  final AccountStore _accountStore;
  final ExpenseStore _expenseStore;
  final IncomeStore _incomeStore;

  @observable
  State<double> initial = const InitialState<double>();

  @observable
  State<double> expected = const InitialState<double>();

  @observable
  State<double> last = const InitialState<double>();

  ReactionDisposer? _accountsReaction;
  ReactionDisposer? _expensesReaction;
  ReactionDisposer? _incomesReaction;
  ReactionDisposer? _monthReaction;

  _BalanceStoreBase({
    required GetBalance usecase,
    required MonthStore monthStore,
    required AccountStore accountStore,
    required ExpenseStore expenseStore,
    required IncomeStore incomeStore,
  })  : _usecase = usecase,
        _monthStore = monthStore,
        _accountStore = accountStore,
        _expenseStore = expenseStore,
        _incomeStore = incomeStore {
    _setUpReactions();
  }

  @action
  Future<void> get() async {
    if (initial is! LoadingState) {
      initial = const LoadingState();

      _fetch(_usecase.initialOf).then((details) {
        var (initialSum, fail) = details;

        initial = fail != null ? FailState(fail) : SuccessState(initialSum);
      });
    }

    if (expected is! LoadingState) {
      expected = const LoadingState();

      _fetch(_usecase.expectedOf).then((details) {
        var (expectedSum, fail) = details;

        expected = fail != null ? FailState(fail) : SuccessState(expectedSum);
      });
    }

    if (last is! LoadingState) {
      last = const LoadingState();

      _fetch(_usecase.finalOf).then((details) {
        var (finalSum, fail) = details;

        last = fail != null ? FailState(fail) : SuccessState(finalSum);
      });
    }
  }

  Future<(double, Fail?)> _fetch(
    _DoubleResult Function({
      required int month,
      required int year,
      required Account account,
    }) func,
  ) async {
    var (:month, :year) = _monthStore.month;

    double sum = 0.00;
    Fail? fail;

    for (var account in _accountStore.visualizingAccounts) {
      var res = await func(month: month, year: year, account: account);

      res.fold((balance) {
        sum = (sum + balance).roundToDecimal();
      }, (f) {
        fail = f;
      });

      if (fail != null) return (0.00, fail);
    }

    return (sum, null);
  }

  void dispose() {
    _accountsReaction?.call();
    _incomesReaction?.call();
    _expensesReaction?.call();
    _monthReaction?.call();
  }

  void _setUpReactions() {
    _accountsReaction = reaction((_) => _accountStore.visualizingAccounts, (_) {
      get();
    });
    _incomesReaction =
        reaction((_) => _incomeStore.state is SuccessState, (condition) {
      if (condition == false) return;

      get();
    });

    _expensesReaction =
        reaction((_) => _expenseStore.state is SuccessState, (condition) {
      if (condition == false) return;

      get();
    });

    _monthReaction = autorun((_) {
      // ignore: unused_local_variable
      var (:month, :year) = _monthStore.month;

      get();
    });
  }
}
