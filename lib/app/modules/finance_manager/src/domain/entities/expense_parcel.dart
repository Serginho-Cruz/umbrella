import 'expense.dart';
import 'parcel.dart';

class ExpenseParcel extends Parcel {
  Expense expense;

  ExpenseParcel({
    required this.expense,
    required super.id,
    required super.paidValue,
    required super.remainingValue,
    required super.paymentDate,
    required super.parcelValue,
  });
}
