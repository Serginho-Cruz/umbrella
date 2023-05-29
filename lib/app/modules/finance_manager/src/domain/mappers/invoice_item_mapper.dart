import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/mappers/expense_parcel_mapper.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/external/schemas/invoice_item_table.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/utils/datetime_extension.dart';

import '../entities/invoice_item.dart';

abstract class InvoiceItemMapper {
  static Map<String, dynamic> toMap({
    required InvoiceItem item,
    required int invoiceId,
  }) =>
      <String, dynamic>{
        InvoiceItemTable.invoiceId: invoiceId,
        InvoiceItemTable.parcelId: item.parcel.id,
        InvoiceItemTable.date: item.date.date,
        InvoiceItemTable.value: item.value,
      };

  static InvoiceItem fromMap(Map<String, dynamic> map) => InvoiceItem(
        value: map[InvoiceItemTable.value] as double,
        date: DateTime.parse(map[InvoiceItemTable.date] as String),
        parcel: ExpenseParcelMapper.fromMap(map),
      );
}
