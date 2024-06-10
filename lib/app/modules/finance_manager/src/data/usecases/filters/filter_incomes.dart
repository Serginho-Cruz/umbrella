import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/usecases/filters/filter_paiyable.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/income.dart';

import '../../../domain/entities/category.dart';
import '../../../domain/usecases/filters/filter_incomes.dart';

class FilterIncomesImpl extends FilterPaiyable<Income>
    implements FilterIncomes {
  @override
  List<Income> byCategory({
    required List<Income> incomes,
    required Category category,
  }) =>
      incomes.where((i) => i.category == category).toList();

  @override
  List<Income> byName({
    required List<Income> incomes,
    required String searchName,
  }) =>
      incomes
          .where((i) => i.name.toLowerCase().contains(searchName.toLowerCase()))
          .toList();
}
