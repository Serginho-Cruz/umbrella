import 'package:equatable/equatable.dart';
import 'date.dart';
import 'expense.dart';
import 'invoice.dart';
import 'paiyable.dart';

class InvoiceItem extends Equatable {
  final double value;
  final Date paymentDate;
  final Paiyable paiyable;

  const InvoiceItem({
    required this.value,
    required this.paymentDate,
    required this.paiyable,
  }) : assert(paiyable is Expense || paiyable is Invoice);

  InvoiceItem copyWith({
    double? value,
    Date? paymentDate,
    Paiyable? paiyable,
    bool? isInterest,
  }) {
    return InvoiceItem(
      value: value ?? this.value,
      paymentDate: paymentDate ?? this.paymentDate,
      paiyable: paiyable ?? this.paiyable,
    );
  }

  @override
  List<Object?> get props => [
        value,
        paymentDate,
        paiyable,
      ];
}
