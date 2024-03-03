import 'package:equatable/equatable.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/date.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/expense.dart';

class InstallmentParcel extends Equatable {
  final Expense expense;
  final int parcelNumber;
  final double value;
  final Date paymentDate;

  const InstallmentParcel({
    required this.expense,
    required this.parcelNumber,
    required this.value,
    required this.paymentDate,
  });

  @override
  List<Object?> get props => [expense, parcelNumber, value, paymentDate];

  InstallmentParcel copyWith({
    Expense? expense,
    int? parcelNumber,
    double? value,
    Date? paymentDate,
  }) {
    return InstallmentParcel(
      expense: expense ?? this.expense,
      parcelNumber: parcelNumber ?? this.parcelNumber,
      paymentDate: paymentDate ?? this.paymentDate,
      value: value ?? this.value,
    );
  }
}
