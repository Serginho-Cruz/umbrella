import 'package:equatable/equatable.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/date.dart';

class InstallmentParcel extends Equatable {
  final int parcelNumber;
  final double value;
  final Date paymentDate;

  const InstallmentParcel({
    required this.parcelNumber,
    required this.value,
    required this.paymentDate,
  });

  @override
  List<Object?> get props => [parcelNumber, value, paymentDate];

  InstallmentParcel copyWith({
    int? parcelNumber,
    double? value,
    Date? paymentDate,
  }) {
    return InstallmentParcel(
      parcelNumber: parcelNumber ?? this.parcelNumber,
      paymentDate: paymentDate ?? this.paymentDate,
      value: value ?? this.value,
    );
  }
}
