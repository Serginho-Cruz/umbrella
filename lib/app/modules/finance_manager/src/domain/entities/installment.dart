// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'credit_card.dart';
import 'expense.dart';
import 'expense_parcel.dart';
import 'payment_method.dart';

class Installment {
  CreditCard? card;
  int parcelsNumber;
  int actualParcel;
  Expense expense;
  PaymentMethod paymentMethod;
  List<ExpenseParcel> parcels;

  Installment({
    this.card,
    required this.parcelsNumber,
    required this.actualParcel,
    required this.expense,
    required this.paymentMethod,
    required this.parcels,
  });
}
