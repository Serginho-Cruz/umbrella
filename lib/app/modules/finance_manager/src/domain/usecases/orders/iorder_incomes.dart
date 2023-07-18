import '../../entities/income_parcel.dart';

abstract class IOrderIncomes {
  List<IncomeParcel> byValue({
    required List<IncomeParcel> parcels,
    required bool isCrescent,
  });
  List<IncomeParcel> byName({
    required List<IncomeParcel> parcels,
    required bool isAlphabetic,
  });
  List<IncomeParcel> byDueDate({
    required List<IncomeParcel> parcels,
    required bool isCrescent,
  });
  List<IncomeParcel> byID(List<IncomeParcel> parcels);
  List<IncomeParcel> revertOrder(List<IncomeParcel> parcels);
}
