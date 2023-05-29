import 'package:equatable/equatable.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/utils/datetime_extension.dart';

import 'parcel.dart';

class Transaction with EquatableMixin {
  int id;
  double value;
  DateTime date;
  Parcel parcel;

  Transaction({
    required this.id,
    required this.value,
    required this.date,
    required this.parcel,
  });

  factory Transaction.withoutId({
    required double value,
    required DateTime date,
    required Parcel parcel,
  }) =>
      Transaction(id: 1, value: value, date: date, parcel: parcel);

  @override
  List<Object?> get props => [id, value, date.date, parcel];
}
