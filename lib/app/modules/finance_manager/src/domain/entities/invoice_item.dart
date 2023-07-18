import 'package:equatable/equatable.dart';

import '../../utils/extensions.dart';
import 'expense_parcel.dart';

class InvoiceItem with EquatableMixin {
  double value;
  DateTime paymentDate;
  ExpenseParcel parcel;

  InvoiceItem({
    required this.value,
    required this.paymentDate,
    required this.parcel,
  });

  @override
  List<Object?> get props => [value, paymentDate.date, parcel];
}
