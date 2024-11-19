import 'package:mobx/mobx.dart';

import '../../domain/entities/account.dart';
import '../../domain/entities/category.dart';
import '../../domain/models/status.dart';
import '../../domain/states/graphs_state.dart';
import '../../domain/usecases/gets/get_graphs_data.dart';
import 'month_store.dart';
part 'graphs_store.g.dart';

// ignore: library_private_types_in_public_api
class GraphsStore = _GraphsStoreBase with _$GraphsStore;

abstract class _GraphsStoreBase with Store {
  final GetGraphsData _usecase;
  final MonthStore _monthStore;

  _GraphsStoreBase({
    required GetGraphsData usecase,
    required MonthStore monthStore,
  })  : _usecase = usecase,
        _monthStore = monthStore;

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
  Future<void> fetchExpenseCategoryGraphData(List<Account> accounts) async {
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
  Future<void> fetchIncomeCategoryGraphData(List<Account> accounts) async {
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
  Future<void> fetchExpenseStatusGraphData(List<Account> accounts) async {
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
  Future<void> fetchIncomeStatusGraphData(List<Account> accounts) async {
    valueReceivedPerStatusState = GraphsLoadingState();

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
}
