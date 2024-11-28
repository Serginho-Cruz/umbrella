import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/usecases/gets/get_expense_categories.dart';

import '../../domain/entities/category.dart';

import 'package:mobx/mobx.dart';

import '../../domain/states/state.dart';
part 'expense_category_store.g.dart';

class ExpenseCategoryStore = _ExpenseCategoryStoreBase
    with _$ExpenseCategoryStore;

abstract class _ExpenseCategoryStoreBase with Store {
  final GetExpenseCategories _usecase;

  @observable
  State<List<Category>> state = const InitialState();

  _ExpenseCategoryStoreBase(this._usecase) {
    getAll();
  }

  @action
  Future<void> getAll() async {
    state = const LoadingState();

    var result = await _usecase();

    state = result.fold((s) => SuccessState(s), (f) => FailState(f));
  }
}
