import '../entities/expense_parcel.dart';
import 'finance_model.dart';

class ExpenseParcelModel extends FinanceModel {
  ExpenseParcelModel({
    required super.id,
    required super.name,
    required super.totalValue,
    required super.paidValue,
    required super.remainingValue,
    required super.status,
    required super.overdueDate,
  });

  static ExpenseParcelModel fromParcel(
    ExpenseParcel parcel, {
    required Status status,
  }) {
    return ExpenseParcelModel(
      id: parcel.id,
      name: parcel.expense.name,
      totalValue: parcel.totalValue,
      paidValue: parcel.paidValue,
      remainingValue: parcel.remainingValue,
      status: status,
      overdueDate: parcel.dueDate,
    );
  }
}
