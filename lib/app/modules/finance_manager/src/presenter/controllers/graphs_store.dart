import 'package:mobx/mobx.dart';

import '../../domain/entities/account.dart';
import '../../domain/entities/category.dart';
import '../../domain/states/graphs_state.dart';
import '../../domain/usecases/gets/get_graphs_data.dart';
part 'graphs_store.g.dart';

// ignore: library_private_types_in_public_api
class GraphsStore = _GraphsStoreBase with _$GraphsStore;

abstract class _GraphsStoreBase with Store {
  final GetGraphsData usecase;

  _GraphsStoreBase({required this.usecase});

  @observable
  GraphsState<Map<Category, double>> valuePerExpenseCategoryState =
      GraphsSuccessState({});

  @observable
  GraphsState<Map<Category, double>> valuePerIncomeCategoryState =
      GraphsSuccessState({});

  @action
  Future<void> fetchExpenseCategoryGraphData(List<Account> accounts) async {
    valuePerExpenseCategoryState = GraphsLoadingState();

    var result = await usecase.valueOfEachExpenseCategory(accounts);

    result.fold((map) {
      valuePerExpenseCategoryState = GraphsSuccessState(map);
    }, (fail) {
      valuePerExpenseCategoryState = GraphsErrorState(fail);
    });
  }

  @action
  Future<void> fetchIncomeCategoryGraphData(List<Account> accounts) async {
    valuePerIncomeCategoryState = GraphsLoadingState();

    var result = await usecase.valueOfEachIncomeCategory(accounts);

    result.fold((map) {
      valuePerIncomeCategoryState = GraphsSuccessState(map);
    }, (fail) {
      valuePerIncomeCategoryState = GraphsErrorState(fail);
    });
  }
}
