import 'package:flutter_triple/flutter_triple.dart';

import '../../domain/entities/income_type.dart';
import '../../domain/usecases/gets/get_income_types.dart';

class IncomeTypeStore extends Store<List<IncomeType>> {
  IncomeTypeStore(GetIncomeTypes usecase)
      : _usecase = usecase,
        super([]) {
    getAll();
  }

  final GetIncomeTypes _usecase;

  Future<void> getAll() async {
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
