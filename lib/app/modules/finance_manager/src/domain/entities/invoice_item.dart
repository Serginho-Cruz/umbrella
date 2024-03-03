import 'package:equatable/equatable.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/expense.dart';
import 'date.dart';

class InvoiceItem extends Equatable {
  final double value;
  final Date paymentDate;
  final Expense expense;
  final bool isAdjust;
  final bool isInterest;

  const InvoiceItem({
    required this.value,
    required this.paymentDate,
    required this.expense,
    this.isAdjust = false,
    this.isInterest = false,
  });

  InvoiceItem copyWith({
    double? value,
    Date? paymentDate,
    Expense? expense,
    bool? isAdjust,
    bool? isInterest,
  }) {
    return InvoiceItem(
      value: value ?? this.value,
      paymentDate: paymentDate ?? this.paymentDate,
      expense: expense ?? this.expense,
      isAdjust: isAdjust ?? false,
      isInterest: isInterest ?? false,
    );
  }

  @override
  List<Object?> get props => [
        value,
        paymentDate,
        expense,
        isAdjust,
        isInterest,
      ];
}
