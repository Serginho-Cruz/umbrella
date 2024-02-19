import '../../domain/entities/income_parcel.dart';

abstract class IIncomeParcelDatasource {
  Future<int> create(IncomeParcel incomeParcel);
  Future<List<IncomeParcel>> getAllOf({
    required int month,
    required int year,
  });
  Future<void> update(IncomeParcel incomeParcel);
  Future<void> delete(IncomeParcel incomeParcel);
}
