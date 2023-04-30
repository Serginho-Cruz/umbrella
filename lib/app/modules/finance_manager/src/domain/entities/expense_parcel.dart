import 'expense.dart';
import 'parcel.dart';
import 'payment_method.dart';

class ExpenseParcel extends Parcel {
  Expense expense;
  PaymentMethod paymentMethod;

  ExpenseParcel({
    required this.expense,
    required this.paymentMethod,
    required super.id,
    required super.paidValue,
    required super.remainingValue,
    required super.paymentDate,
    required super.parcelValue,
  });
}
