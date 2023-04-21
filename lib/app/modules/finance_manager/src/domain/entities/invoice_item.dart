import 'expense_parcel.dart';

class InvoiceItem {
  double value;
  DateTime date;
  ExpenseParcel parcel;

  InvoiceItem({
    required this.value,
    required this.date,
    required this.parcel,
  });
}
