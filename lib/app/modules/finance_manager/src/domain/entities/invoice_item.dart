import 'package:equatable/equatable.dart';

import '../../utils/extensions.dart';
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
