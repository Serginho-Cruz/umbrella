import 'income_mapper.dart';
import '../../external/schemas/income_parcel_table.dart';
import '../../utils/extensions.dart';

import '../entities/income_parcel.dart';

abstract class IncomeParcelMapper {
  static Map<String, dynamic> toMap(IncomeParcel parcel) => {
        IncomeParcelTable.id: parcel.id,
        IncomeParcelTable.paidValue: parcel.paidValue,
        IncomeParcelTable.parcelValue: parcel.parcelValue,
        IncomeParcelTable.paymentDate: parcel.paymentDate.date,
        IncomeParcelTable.remainingValue: parcel.remainingValue,
        IncomeParcelTable.incomeId: parcel.income.id,
      };

  static IncomeParcel fromMap(Map<String, dynamic> map) => IncomeParcel(
        income: IncomeMapper.fromMap(map),
        id: map[IncomeParcelTable.id] as int,
        paidValue: map[IncomeParcelTable.paidValue] as double,
        remainingValue: map[IncomeParcelTable.remainingValue] as double,
        paymentDate:
            DateTime.parse(map[IncomeParcelTable.paymentDate] as String),
        parcelValue: map[IncomeParcelTable.parcelValue] as double,
      );
}
