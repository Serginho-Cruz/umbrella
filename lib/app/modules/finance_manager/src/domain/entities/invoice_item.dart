import 'package:equatable/equatable.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/utils/datetime_extension.dart';

import 'expense_parcel.dart';

class InvoiceItem with EquatableMixin {
  double value;
  DateTime date;
  ExpenseParcel parcel;

  InvoiceItem({
    required this.value,
    required this.date,
    required this.parcel,
  });

  @override
  List<Object?> get props => [value, date.date, parcel];
}
