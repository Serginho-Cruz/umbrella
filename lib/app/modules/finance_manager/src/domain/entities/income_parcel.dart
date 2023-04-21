import 'income.dart';
import 'parcel.dart';

class IncomeParcel extends Parcel {
  Income income;

  IncomeParcel({
    required this.income,
    required super.id,
    required super.paidValue,
    required super.remainingValue,
    required super.paymentDate,
    required super.parcelValue,
  });
}
