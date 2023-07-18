import '../../entities/expense_parcel.dart';
import '../../entities/expense_type.dart';

abstract class IFilterExpenses {
  List<ExpenseParcel> byName({
    required List<ExpenseParcel> expenses,
    required String searchName,
  });
  List<ExpenseParcel> byPaid(List<ExpenseParcel> expenses);
  List<ExpenseParcel> byUnpaid(List<ExpenseParcel> expenses);
  List<ExpenseParcel> byOverdue(List<ExpenseParcel> expenses);
  List<ExpenseParcel> byType({
    required List<ExpenseParcel> expenses,
    required ExpenseType type,
  });
}
