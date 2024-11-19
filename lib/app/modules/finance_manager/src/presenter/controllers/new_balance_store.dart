import 'package:mobx/mobx.dart';
import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/utils/round.dart';

import '../../domain/entities/account.dart';
import '../../domain/states/state.dart';
import '../../domain/usecases/gets/get_balance.dart';
import '../../errors/errors.dart';
import 'month_store.dart';
part 'new_balance_store.g.dart';

class NewBalanceStore = _NewBalanceStoreBase with _$NewBalanceStore;

typedef _DoubleResult = Future<Result<double, Fail>>;

abstract class _NewBalanceStoreBase with Store {
  final GetBalance _usecase;
  final MonthStore _monthStore;

  @observable
  State<double> initial = const InitialState<double>();

  @observable
  State<double> expected = const InitialState<double>();

  @observable
  State<double> last = const InitialState<double>();

  _NewBalanceStoreBase({
    required GetBalance usecase,
    required MonthStore monthStore,
  })  : _usecase = usecase,
        _monthStore = monthStore;

  Future<void> get({
    required Account account,
  }) async {
    getForAll(accounts: [account]);
  }

  Future<void> getForAll({
    required List<Account> accounts,
  }) async {
    if (initial is! LoadingState) {
      initial = const LoadingState();

      _fetch(_usecase.initialOf, accs: accounts).then((details) {
        var (initialSum, fail) = details;

        initial = fail != null ? FailState(fail) : SuccessState(initialSum);
      });
    }

    if (expected is! LoadingState) {
      expected = const LoadingState();

      _fetch(_usecase.expectedOf, accs: accounts).then((details) {
        var (expectedSum, fail) = details;

        expected = fail != null ? FailState(fail) : SuccessState(expectedSum);
      });
    }

    if (last is! LoadingState) {
      last = const LoadingState();

      _fetch(_usecase.finalOf, accs: accounts).then((details) {
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
    }) func, {
    required List<Account> accs,
  }) async {
    var (:month, :year) = _monthStore.month;

    double sum = 0.00;
    Fail? fail;

    for (var account in accs) {
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
}
