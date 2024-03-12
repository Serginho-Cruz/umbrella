import '../entities/income.dart';
import 'finance_model.dart';

class IncomeModel extends FinanceModel {
  IncomeModel({
    required super.id,
    required super.name,
    required super.totalValue,
    required super.paidValue,
    required super.remainingValue,
    required super.status,
    required super.overdueDate,
  });

  static IncomeModel fromParcel(
    Income parcel, {
    required Status status,
  }) {
    return IncomeModel(
      id: parcel.id,
      name: parcel.name,
      totalValue: parcel.totalValue,
      paidValue: parcel.paidValue,
      remainingValue: parcel.remainingValue,
      status: status,
      overdueDate: parcel.dueDate,
    );
  }
}
