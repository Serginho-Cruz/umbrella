import '../../entities/expense_parcel.dart';

abstract class IOrderExpenses {
  List<ExpenseParcel> byValue({
    required List<ExpenseParcel> parcels,
    required bool isCrescent,
  });
  List<ExpenseParcel> byName({
    required List<ExpenseParcel> parcels,
    required bool isAlphabetic,
  });
  List<ExpenseParcel> byDueDate({
    required List<ExpenseParcel> parcels,
    required bool isCrescent,
  });
  List<ExpenseParcel> byID(List<ExpenseParcel> parcels);
  List<ExpenseParcel> revertOrder(List<ExpenseParcel> parcels);
}
