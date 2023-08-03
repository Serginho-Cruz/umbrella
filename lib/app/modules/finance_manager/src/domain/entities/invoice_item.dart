import 'package:equatable/equatable.dart';

import '../../utils/extensions.dart';
import 'expense_parcel.dart';

class InvoiceItem extends Equatable {
  final double value;
  final DateTime paymentDate;
  final ExpenseParcel parcel;

  const InvoiceItem({
    required this.value,
    required this.paymentDate,
    required this.parcel,
  });

  InvoiceItem copyWith({
    double? value,
    DateTime? paymentDate,
    ExpenseParcel? parcel,
  }) {
    return InvoiceItem(
      value: value ?? this.value,
      paymentDate: paymentDate ?? this.paymentDate,
      parcel: parcel ?? this.parcel,
    );
  }

  @override
  List<Object?> get props => [value, paymentDate.date, parcel];
}
