import 'package:equatable/equatable.dart';

import 'paiyable.dart';
import 'expense_parcel.dart';
import 'invoice.dart';

class InstallmentParcel extends Equatable {
  final Paiyable paiyable;
  final int parcelNumber;

  const InstallmentParcel({
    required this.paiyable,
    required this.parcelNumber,
  }) : assert(paiyable is Invoice || paiyable is ExpenseParcel);

  @override
  List<Object?> get props => [paiyable, parcelNumber];
}
