import 'package:umbrella_echonomics/app/modules/finance_manager/src/utils/datetime_extension.dart';

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

  @override
  List<Object?> get props => [
        income,
        id,
        paidValue,
        remainingValue,
        paymentDate.date,
        parcelValue,
      ];
}
