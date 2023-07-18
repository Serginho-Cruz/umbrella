import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/expense_parcel.dart';

import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/expense_type.dart';

import '../../../domain/usecases/filters/ifilter_expenses.dart';

class FilterExpenses implements IFilterExpenses {
  @override
  List<ExpenseParcel> byPaid(List<ExpenseParcel> expenses) =>
      expenses.where((parcel) => parcel.remainingValue == 0).toList();

  @override
  List<ExpenseParcel> byUnpaid(List<ExpenseParcel> expenses) =>
      expenses.where((parcel) => parcel.remainingValue > 0).toList();

  @override
  List<ExpenseParcel> byOverdue(List<ExpenseParcel> expenses) => expenses
      .where((parcel) =>
          parcel.dueDate.difference(DateTime.now()).inDays < 0 &&
          parcel.remainingValue > 0)
      .toList();

  @override
  List<ExpenseParcel> byName({
    required List<ExpenseParcel> expenses,
    required String searchName,
  }) =>
      expenses
          .where((parcel) => parcel.expense.name
              .toLowerCase()
              .contains(searchName.toLowerCase()))
          .toList();

  @override
  List<ExpenseParcel> byType({
    required List<ExpenseParcel> expenses,
    required ExpenseType type,
  }) =>
      expenses.where((parcel) => parcel.expense.type == type).toList();
}
