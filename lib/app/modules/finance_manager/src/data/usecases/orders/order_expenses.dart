import '../../../domain/entities/expense_parcel.dart';
import '../../../domain/usecases/orders/iorder_expenses.dart';

class OrderExpenses implements IOrderExpenses {
  @override
  List<ExpenseParcel> byID(List<ExpenseParcel> parcels) => List.from(parcels)
    ..sort((parcel1, parcel2) => parcel1.id.compareTo(parcel2.id));

  @override
  List<ExpenseParcel> byName({
    required List<ExpenseParcel> parcels,
    required bool isAlphabetic,
  }) =>
      _sortList(
        sortFunction: (a, b) => a.expense.name.compareTo(b.expense.name),
        parcels: parcels,
        isCrescent: isAlphabetic,
      );

  @override
  List<ExpenseParcel> byValue({
    required List<ExpenseParcel> parcels,
    required bool isCrescent,
  }) =>
      _sortList(
        sortFunction: (a, b) => a.totalValue.compareTo(b.totalValue),
        isCrescent: isCrescent,
        parcels: parcels,
      );

  @override
  List<ExpenseParcel> byDueDate({
    required List<ExpenseParcel> parcels,
    required bool isCrescent,
  }) =>
      _sortList(
        sortFunction: (a, b) => a.dueDate.compareTo(b.dueDate),
        isCrescent: isCrescent,
        parcels: parcels,
      );

  @override
  List<ExpenseParcel> revertOrder(List<ExpenseParcel> parcels) =>
      parcels.reversed.toList();

  List<ExpenseParcel> _sortList({
    required int Function(ExpenseParcel, ExpenseParcel) sortFunction,
    required List<ExpenseParcel> parcels,
    required bool isCrescent,
  }) {
    //Multiplier Number in compare will order the list in crescent or decrescent
    //without using .reverse in the final of processing, saving cellphone resources
    int multiplierNumber = isCrescent ? 1 : -1;
    return List.from(parcels)
      ..sort((a, b) => sortFunction(a, b) * multiplierNumber);
  }
}
