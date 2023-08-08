import 'package:equatable/equatable.dart';

import '../../utils/extensions.dart';
import 'expense_parcel.dart';

class InvoiceItem extends Equatable {
  final double value;
  final DateTime paymentDate;
  final ExpenseParcel parcel;
  final bool isAdjust;
  final bool isInterest;

  const InvoiceItem({
    required this.value,
    required this.paymentDate,
    required this.parcel,
    this.isAdjust = false,
    this.isInterest = false,
  });

  InvoiceItem copyWith({
    double? value,
    DateTime? paymentDate,
    ExpenseParcel? parcel,
    bool? isAdjust,
    bool? isInterest,
  }) {
    return InvoiceItem(
      value: value ?? this.value,
      paymentDate: paymentDate ?? this.paymentDate,
      parcel: parcel ?? this.parcel,
      isAdjust: isAdjust ?? false,
      isInterest: isInterest ?? false,
    );
  }

  @override
  List<Object?> get props => [
        value,
        paymentDate.date,
        parcel,
        isAdjust,
        isInterest,
      ];
}
