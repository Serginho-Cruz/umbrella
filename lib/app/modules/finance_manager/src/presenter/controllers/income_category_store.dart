import '../../domain/entities/category.dart';

import 'package:mobx/mobx.dart';

import '../../domain/states/state.dart';
import '../../domain/usecases/gets/get_income_categories.dart';
part 'income_category_store.g.dart';

class IncomeCategoryStore = _IncomeCategoryStoreBase with _$IncomeCategoryStore;

abstract class _IncomeCategoryStoreBase with Store {
  final GetIncomeCategories _usecase;

  @observable
  State<List<Category>> state = const InitialState();

  _IncomeCategoryStoreBase(this._usecase) {
    getAll();
  }

  @action
  Future<void> getAll() async {
    state = const LoadingState();

    var result = await _usecase();

    state = result.fold((s) => SuccessState(s), (f) => FailState(f));
  }
}
