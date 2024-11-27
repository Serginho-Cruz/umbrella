import 'package:mobx/mobx.dart';

import '../../domain/entities/category.dart';
import '../../domain/models/status.dart';
import '../../domain/states/graphs_state.dart';
import '../../domain/usecases/gets/get_graphs_data.dart';
import 'account_store.dart';
import 'month_store.dart';
part 'graphs_store.g.dart';

// ignore: library_private_types_in_public_api
class GraphsStore = _GraphsStoreBase with _$GraphsStore;

abstract class _GraphsStoreBase with Store {
  final GetGraphsData _usecase;
  final MonthStore _monthStore;
  final AccountStore _accountStore;

  _GraphsStoreBase({
    required GetGraphsData usecase,
    required MonthStore monthStore,
    required AccountStore accountStore,
  })  : _usecase = usecase,
        _monthStore = monthStore,
        _accountStore = accountStore;

  @observable
  GraphsState<Map<Category, double>> valuePerExpenseCategoryState =
      GraphsSuccessState({});

  @observable
  GraphsState<Map<Category, double>> valuePerIncomeCategoryState =
      GraphsSuccessState({});

  @observable
  GraphsState<Map<Status, double>> valueCastPerStatusState =
      GraphsSuccessState({});

  @observable
  GraphsState<Map<Status, double>> valueReceivedPerStatusState =
      GraphsSuccessState({});

  @action
  Future<void> fetchExpenseCategoryGraphData() async {
    var accounts = _accountStore.visualizingAccounts;

    if (accounts.isEmpty) return;

    valuePerExpenseCategoryState = GraphsLoadingState();

    var (:month, :year) = _monthStore.month;

    var result = await _usecase.valueOfEachExpenseCategory(
      accounts: accounts,
      month: month,
      year: year,
    );

    result.fold((map) {
      valuePerExpenseCategoryState = GraphsSuccessState(map);
    }, (fail) {
      valuePerExpenseCategoryState = GraphsErrorState(fail);
    });
  }

  @action
  Future<void> fetchIncomeCategoryGraphData() async {
    var accounts = _accountStore.visualizingAccounts;

    if (accounts.isEmpty) return;
    valuePerIncomeCategoryState = GraphsLoadingState();

    var (:month, :year) = _monthStore.month;

    var result = await _usecase.valueOfEachIncomeCategory(
      accounts: accounts,
      month: month,
      year: year,
    );

    result.fold((map) {
      valuePerIncomeCategoryState = GraphsSuccessState(map);
    }, (fail) {
      valuePerIncomeCategoryState = GraphsErrorState(fail);
    });
  }

  @action
  Future<void> fetchExpenseStatusGraphData() async {
    var accounts = _accountStore.visualizingAccounts;

    if (accounts.isEmpty) return;
    valueCastPerStatusState = GraphsLoadingState();

    var (:month, :year) = _monthStore.month;

    var result = await _usecase.valueForEachExpenseStatus(
      accounts: accounts,
      month: month,
      year: year,
    );

    result.fold((map) {
      valueCastPerStatusState = GraphsSuccessState(map);
    }, (fail) {
      valueCastPerStatusState = GraphsErrorState(fail);
    });
  }

  @action
  Future<void> fetchIncomeStatusGraphData() async {
    var accounts = _accountStore.visualizingAccounts;

    if (accounts.isEmpty) return;

    var (:month, :year) = _monthStore.month;

    var result = await _usecase.valueForEachIncomeStatus(
      accounts: accounts,
      month: month,
      year: year,
    );

    result.fold((map) {
      valueReceivedPerStatusState = GraphsSuccessState(map);
    }, (fail) {
      valueReceivedPerStatusState = GraphsErrorState(fail);
    });
  }

  @action
  void clearData() {
    valueCastPerStatusState = GraphsSuccessState({});
    valuePerExpenseCategoryState = GraphsSuccessState({});
    valuePerIncomeCategoryState = GraphsSuccessState({});
    valueReceivedPerStatusState = GraphsSuccessState({});
  }
}
