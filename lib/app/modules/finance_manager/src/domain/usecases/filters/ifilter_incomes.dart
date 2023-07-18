import '../../entities/income_parcel.dart';
import '../../entities/income_type.dart';

abstract class IFilterIncomes {
  List<IncomeParcel> byName({
    required List<IncomeParcel> incomes,
    required String searchName,
  });
  List<IncomeParcel> byReceived(List<IncomeParcel> incomes);
  List<IncomeParcel> byUnreceived(List<IncomeParcel> incomes);
  List<IncomeParcel> byOverdue(List<IncomeParcel> incomes);
  List<IncomeParcel> byType({
    required List<IncomeParcel> incomes,
    required IncomeType type,
  });
}
