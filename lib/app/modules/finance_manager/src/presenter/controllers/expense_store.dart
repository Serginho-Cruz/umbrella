import 'package:flutter_triple/flutter_triple.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/models/expense_parcel_model.dart';

import '../../domain/entities/date.dart';
import '../../domain/models/finance_model.dart';

class ExpenseStore extends Store<List<ExpenseParcelModel>> {
  ExpenseStore() : super([]);

  Future<void> getAll() async {
    setLoading(true);

    await Future.delayed(const Duration(seconds: 5), () {
      var expenses = List.generate(
        5,
        (index) => ExpenseParcelModel(
            id: index,
            name: 'Despesa ${index + 1}',
            totalValue: 549.99 * index,
            paidValue: 549.99 * index,
            remainingValue: 0,
            status: Status.values[index % 3],
            overdueDate: Date.today()),
      );

      update(expenses);
    });

    setLoading(false);
  }
}
