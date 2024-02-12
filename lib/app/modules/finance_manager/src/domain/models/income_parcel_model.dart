import '../entities/income_parcel.dart';
import 'finance_model.dart';

class IncomeParcelModel extends FinanceModel {
  IncomeParcelModel({
    required super.id,
    required super.name,
    required super.totalValue,
    required super.paidValue,
    required super.remainingValue,
    required super.status,
    required super.overdueDate,
  });

  static IncomeParcelModel fromParcel(
    IncomeParcel parcel, {
    required Status status,
  }) {
    return IncomeParcelModel(
      id: parcel.id,
      name: parcel.income.name,
      totalValue: parcel.totalValue,
      paidValue: parcel.paidValue,
      remainingValue: parcel.remainingValue,
      status: status,
      overdueDate: parcel.dueDate,
    );
  }
}
