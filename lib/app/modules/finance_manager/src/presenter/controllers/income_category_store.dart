import 'package:flutter_triple/flutter_triple.dart';

import '../../domain/entities/category.dart';
import '../../domain/usecases/gets/get_income_categories.dart';

class IncomeCategoryStore extends Store<List<Category>> {
  IncomeCategoryStore(GetIncomeCategories usecase)
      : _usecase = usecase,
        super([]) {
    getAll();
  }

  final GetIncomeCategories _usecase;

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
