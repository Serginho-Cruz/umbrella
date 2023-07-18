import '../../entities/income_parcel.dart';

abstract class IOrderIncomes {
  List<IncomeParcel> byValue({
    required List<IncomeParcel> parcels,
    required bool isCrescent,
  });
  List<IncomeParcel> byName({
    required List<IncomeParcel> parcels,
    required bool isCrescent,
  });
  List<IncomeParcel> byPaymentDate({
    required List<IncomeParcel> parcels,
    required bool isCrescent,
  });
  List<IncomeParcel> byID(List<IncomeParcel> parcels);
}
