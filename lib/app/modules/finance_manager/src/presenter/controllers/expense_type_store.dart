import 'package:flutter_triple/flutter_triple.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/expense_type.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/usecases/gets/get_expense_types.dart';

class ExpenseTypeStore extends Store<List<ExpenseType>> {
  ExpenseTypeStore(GetExpenseTypes usecase)
      : _usecase = usecase,
        super([]) {
    getAll();
  }

  final GetExpenseTypes _usecase;

  Future<void> getAll() async {
    var result = await _usecase();

    result.fold((list) {
      update(list);
    }, (fail) {
      setError(fail);
    });
  }
}
