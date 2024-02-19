import '../../domain/entities/expense_parcel.dart';

abstract class IExpenseParcelDatasource {
  Future<int> create(ExpenseParcel expenseParcel);
  Future<List<int>> createAll(List<ExpenseParcel> expenseParcels);
  Future<List<ExpenseParcel>> getAllOf({
    required int month,
    required int year,
  });
  Future<void> update(ExpenseParcel expenseParcel);
  Future<void> updateAll(List<ExpenseParcel> expenseParcels);
  Future<void> delete(ExpenseParcel expenseParcel);
  Future<void> deleteAll(List<ExpenseParcel> expenseParcels);
}
