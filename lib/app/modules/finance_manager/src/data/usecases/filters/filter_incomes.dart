import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/usecases/filters/filter_paiyable.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/income.dart';

import '../../../domain/entities/income_type.dart';
import '../../../domain/usecases/filters/filter_incomes.dart';

class FilterIncomesImpl extends FilterPaiyable<Income>
    implements FilterIncomes {
  @override
  List<Income> byType({
    required List<Income> incomes,
    required IncomeType type,
  }) =>
      incomes.where((i) => i.type == type).toList();

  @override
  List<Income> byName({
    required List<Income> incomes,
    required String searchName,
  }) =>
      incomes
          .where((i) => i.name.toLowerCase().contains(searchName.toLowerCase()))
          .toList();
}
