import 'package:flutter_triple/flutter_triple.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/usecases/gets/get_expense_categories.dart';

import '../../domain/entities/category.dart';

class ExpenseCategoryStore extends Store<List<Category>> {
  ExpenseCategoryStore(GetExpenseCategories usecase)
      : _usecase = usecase,
        super([]) {
    getAll();
  }

  final GetExpenseCategories _usecase;

  Future<void> getAll() async {
    if (state.isNotEmpty) return;
    setLoading(true);
    var result = await _usecase();

    result.fold((list) {
      update(list);
    }, (fail) {
      setError(fail);
    });

    setLoading(false);
  }
}
