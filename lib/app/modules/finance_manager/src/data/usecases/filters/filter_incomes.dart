import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/income_parcel.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/income_type.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/usecases/filters/ifilter_incomes.dart';

class FilterIncomes implements IFilterIncomes {
  @override
  List<IncomeParcel> byName({
    required List<IncomeParcel> incomes,
    required String searchName,
  }) =>
      incomes
          .where((parcel) => parcel.income.name
              .toLowerCase()
              .contains(searchName.toLowerCase()))
          .toList();
  @override
  List<IncomeParcel> byOverdue(List<IncomeParcel> incomes) => incomes
      .where((parcel) =>
          parcel.remainingValue > 0 &&
          parcel.dueDate.difference(DateTime.now()).inDays < 0)
      .toList();

  @override
  List<IncomeParcel> byReceived(List<IncomeParcel> incomes) =>
      incomes.where((parcel) => parcel.remainingValue == 0).toList();

  @override
  List<IncomeParcel> byType({
    required List<IncomeParcel> incomes,
    required IncomeType type,
  }) =>
      incomes.where((parcel) => parcel.income.type == type).toList();

  @override
  List<IncomeParcel> byUnreceived(List<IncomeParcel> incomes) =>
      incomes.where((parcel) => parcel.remainingValue > 0).toList();
}
