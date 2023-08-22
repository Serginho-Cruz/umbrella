import 'package:equatable/equatable.dart';

import 'expense_parcel.dart';

class InstallmentParcel extends Equatable {
  final ExpenseParcel parcel;
  final int parcelNumber;

  const InstallmentParcel({
    required this.parcel,
    required this.parcelNumber,
  });

  @override
  List<Object?> get props => [parcel, parcelNumber];

  InstallmentParcel copyWith({
    ExpenseParcel? parcel,
    int? parcelNumber,
  }) {
    return InstallmentParcel(
      parcel: parcel ?? this.parcel,
      parcelNumber: parcelNumber ?? this.parcelNumber,
    );
  }
}
