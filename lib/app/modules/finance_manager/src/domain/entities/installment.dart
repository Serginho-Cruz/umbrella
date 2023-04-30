import 'credit_card.dart';
import 'expense.dart';
import 'expense_parcel.dart';
import 'payment_method.dart';

class Installment {
  int id;
  CreditCard? card;
  int parcelsNumber;
  int actualParcel;
  Expense expense;
  PaymentMethod paymentMethod;
  List<ExpenseParcel> parcels;

  Installment({
    required this.id,
    this.card,
    required this.parcelsNumber,
    required this.actualParcel,
    required this.expense,
    required this.paymentMethod,
    required this.parcels,
  });
}
