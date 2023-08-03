import 'package:equatable/equatable.dart';

import 'expense_parcel.dart';
import 'invoice.dart';
import 'paiyable.dart';

class InstallmentParcel extends Equatable {
  final Paiyable paiyable;
  final int parcelNumber;

  const InstallmentParcel({
    required this.paiyable,
    required this.parcelNumber,
  }) : assert(paiyable is Invoice || paiyable is ExpenseParcel);

  @override
  List<Object?> get props => [paiyable, parcelNumber];

  InstallmentParcel copyWith({
    Paiyable? paiyable,
    int? parcelNumber,
  }) {
    return InstallmentParcel(
      paiyable: paiyable ?? this.paiyable,
      parcelNumber: parcelNumber ?? this.parcelNumber,
    );
  }
}
