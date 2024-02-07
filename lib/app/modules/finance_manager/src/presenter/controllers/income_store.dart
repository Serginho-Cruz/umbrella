import 'package:flutter_triple/flutter_triple.dart';

import '../../domain/entities/date.dart';
import '../../domain/models/finance_model.dart';
import '../../domain/models/income_parcel_model.dart';

class IncomeStore extends Store<List<IncomeParcelModel>> {
  IncomeStore() : super([]);

  Future<void> getAll() async {
    setLoading(true);

    await Future.delayed(const Duration(seconds: 5), () {
      var incomes = List.generate(
        5,
        (index) => IncomeParcelModel(
            id: index,
            name: 'Receita ${index + 1}',
            totalValue: 159.99 * index,
            paidValue: 209.99 * index,
            remainingValue: 0.0,
            status: Status.values[index % 3],
            overdueDate: Date.today()),
      );

      update(incomes);
    });

    setLoading(false);
  }
}
