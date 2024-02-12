import '../../../domain/entities/income_parcel.dart';
import '../../../domain/usecases/orders/iorder_incomes.dart';

class OrderIncomes implements IOrderIncomes {
  @override
  List<IncomeParcel> byID(List<IncomeParcel> parcels) =>
      List.from(parcels)..sort((a, b) => a.id.compareTo(b.id));

  @override
  List<IncomeParcel> byName({
    required List<IncomeParcel> parcels,
    required bool isAlphabetic,
  }) =>
      _sortList(
        sortFunction: (a, b) => a.income.name.compareTo(b.income.name),
        parcels: parcels,
        isCrescent: isAlphabetic,
      );

  @override
  List<IncomeParcel> byValue({
    required List<IncomeParcel> parcels,
    required bool isCrescent,
  }) =>
      _sortList(
        sortFunction: (a, b) => a.totalValue.compareTo(b.totalValue),
        parcels: parcels,
        isCrescent: isCrescent,
      );

  @override
  List<IncomeParcel> byDueDate({
    required List<IncomeParcel> parcels,
    required bool isCrescent,
  }) =>
      _sortList(
        sortFunction: (a, b) => a.dueDate.compareTo(b.dueDate),
        parcels: parcels,
        isCrescent: isCrescent,
      );

  @override
  List<IncomeParcel> revertOrder(List<IncomeParcel> parcels) =>
      parcels.reversed.toList();

  List<IncomeParcel> _sortList({
    required int Function(IncomeParcel, IncomeParcel) sortFunction,
    required List<IncomeParcel> parcels,
    required bool isCrescent,
  }) {
    //Multiplier Number in compare will order the list in crescent or decrescent
    //without using .reverse in the final of processing, saving cellphone resources

    int multiplierNumber = isCrescent ? 1 : -1;
    return List.from(parcels)
      ..sort((a, b) => sortFunction(a, b) * multiplierNumber);
  }
}
