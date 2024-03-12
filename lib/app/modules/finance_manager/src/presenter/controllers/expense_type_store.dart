import 'package:flutter_triple/flutter_triple.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/expense_type.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/usecases/gets/iget_expense_types.dart';

class ExpenseTypeStore extends Store<List<ExpenseType>> {
  ExpenseTypeStore(IGetExpenseTypes usecase) : super([]) {
    _usecase = usecase;
  }

  late final IGetExpenseTypes _usecase;

  Future<void> getAll() async {
    var result = await _usecase();

    result.fold((list) {
      update(list);
    }, (fail) {
      setError(fail);
    });
  }
}
