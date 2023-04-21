import 'parcel.dart';

class Transaction {
  double value;
  DateTime date;
  Parcel parcel;

  Transaction({
    required this.value,
    required this.date,
    required this.parcel,
  });
}
