import 'paiyable.dart';
import 'expense_parcel.dart';
import 'invoice.dart';

class InstallmentParcel {
  Paiyable paiyable;
  int parcelNumber;

  InstallmentParcel({
    required this.paiyable,
    required this.parcelNumber,
  }) : assert(paiyable is Invoice || paiyable is ExpenseParcel);
}
